# List all available recipes
default:
    @just --list

# Rebuild Tailwind CSS on every change to the input CSS or templates
watch:
    @tailwindcss -i static/css/_style.css -o static/css/style.css --watch

# Build the Tailwind stylesheet once
css:
    @tailwindcss -i static/css/_style.css -o static/css/style.css

# Build CSS then run the Zola dev server (live reload on http://127.0.0.1:1111)
serve: css
    @zola serve

# Build the static site into `public/` (production build)
build:
    @zola build

# Excludes analog.com (rate-limits bots); tolerates 100/103/403/429; deletes `public/` after.
# Build the site and run the lychee link checker against the generated `public/`
lychee:
    @just build
    @lychee --root-dir public public --exclude ".+\.analog.com" --accept 100..=103,200..=299,403,429
    @rm -r public

# djlint --reformat exits 1 on every rewrite, so swallow that here only.
# Format Tera templates with djlint (config in .djlintrc; `brew install djlint`)
format:
    @djlint templates --reformat || true

# Check template formatting without writing — used in CI / pre-commit
format-check:
    @djlint templates --check
