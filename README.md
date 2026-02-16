# Munich Embedded Website

This is the source code for the website available at https://www.munich-embedded.com

It is a static website, built with Zola and hosted at Cloudflare pages.

## Requirements

- Static Site Generator: Zola v0.20.2 https://www.getzola.org/documentation/getting-started/installation
- CSS Framework: tailwindcss v4.1.10 https://tailwindcss.com/docs/installation/tailwind-cli (can be installed via brew)
- Optional: Just command runner https://github.com/casey/just

## Building the Site

- If css was changed: rebuild with tailwind by running `just css`
- Preview website locally with `zola serve`

## Scripts

- `./scripts/geocode.sh` — Resolves coordinates for ecosystem entities that have an `address` but no `lat`/`lon`. Uses OpenStreetMap Nominatim. Pass `-f` to re-geocode all entries. Requires `curl` and `jq`.

***
Systemscape GmbH  | 2025\
https://www.systemscape.com
