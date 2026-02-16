#!/usr/bin/env bash
# Geocodes entities in ecosystem markdown files that have an address but no lat/lon.
# Uses OpenStreetMap Nominatim (free, no API key needed).
# Usage: ./scripts/geocode.sh [-f] [file ...]
#   -f    Force: re-geocode all entities, even those that already have lat/lon
# If no files given, processes all ecosystem _index*.md files.

set -euo pipefail
export LC_NUMERIC=C

force=false
if [ "${1:-}" = "-f" ]; then
    force=true
    shift
fi

if [ $# -gt 0 ]; then
    files=("$@")
else
    files=(content/ecosystem/_index*.md)
fi

if ! command -v jq &>/dev/null; then
    echo "Error: jq is required. Install it with: sudo apt install jq" >&2
    exit 1
fi

for file in "${files[@]}"; do
    echo "Processing $file ..."
    tmpfile=$(mktemp)
    changed=false

    while IFS= read -r line; do
        # Match lines with address (skip if lat exists, unless -f)
        if echo "$line" | grep -q 'address\s*=' && { [ "$force" = true ] || ! echo "$line" | grep -q 'lat\s*='; }; then
            # Strip existing lat/lon if forcing
            if [ "$force" = true ]; then
                line=$(echo "$line" | sed 's/,\s*lat\s*=\s*[0-9.-]*//; s/,\s*lon\s*=\s*[0-9.-]*//')
            fi
            # Extract the address value
            address=$(echo "$line" | sed -n 's/.*address\s*=\s*"\([^"]*\)".*/\1/p')
            if [ -n "$address" ]; then
                echo "  Geocoding: $address"
                # Query Nominatim with 1s delay to respect usage policy
                sleep 1
                result=$(curl -sG "https://nominatim.openstreetmap.org/search" \
                    --data-urlencode "q=$address" \
                    -d "format=json" \
                    -d "limit=1" \
                    -H "User-Agent: munich-embedded-geocoder")

                lat=$(echo "$result" | jq -r '.[0].lat // empty')
                lon=$(echo "$result" | jq -r '.[0].lon // empty')

                if [ -n "$lat" ] && [ -n "$lon" ]; then
                    # Round to 4 decimal places
                    lat=$(printf "%.4f" "$lat")
                    lon=$(printf "%.4f" "$lon")
                    echo "    -> lat = $lat, lon = $lon"
                    # Insert lat and lon before the closing }
                    line=$(echo "$line" | sed "s/}/, lat = $lat, lon = $lon }/")
                    changed=true
                else
                    echo "    -> No result found, skipping" >&2
                fi
            fi
        fi
        echo "$line" >> "$tmpfile"
    done < "$file"

    if [ "$changed" = true ]; then
        mv "$tmpfile" "$file"
        echo "  Updated $file"
    else
        rm "$tmpfile"
        echo "  No changes needed"
    fi
done
