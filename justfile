# List all available recipes (default when running `just` with no args)
default:
    @just --list

# Rebuild the Tailwind stylesheet on every change to the input CSS or templates
watch:
    @tailwindcss -i static/css/_style.css -o static/css/style.css --watch

# Build the Tailwind stylesheet once
css:
    @tailwindcss -i static/css/_style.css -o static/css/style.css

# Build CSS, then run the local Zola dev server (live reload on http://127.0.0.1:1111)
serve: css
    @zola serve

# Build the static site into `public/` (production build)
build:
    @zola build

# Build the site and run the lychee link checker against the generated `public/`,
# excluding analog.com (which rate-limits/blocks bots) and tolerating a few
# common non-2xx responses. Cleans up `public/` afterwards.
lychee:
    @just build
    @lychee --root-dir public public --exclude ".+\.analog.com" --accept 100..=103,200..=299,403,429
    @rm -r public

# Format Tera templates with djlint (`brew install djlint`). Settings are read
# from .djlintrc (jinja profile, indent 4, max_line_length 160).
# djlint exits 1 when it rewrites files, which isn't an error for `just format`.
format:
    @djlint templates --reformat || true

# Check formatting without modifying files. Use this in CI or before committing.
format-check:
    @djlint templates --check
