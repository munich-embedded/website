default:
    @just --list

watch:
    @tailwindcss -i static/css/_style.css -o static/css/style.css --watch

css:
    @tailwindcss -i static/css/_style.css -o static/css/style.css

serve: css
    @zola serve

build:
    @zola build

lychee:
    @just build
    @lychee --root-dir public public --exclude ".+\.analog.com" --exclude "https://ilbers.de/" --accept 100..=103,200..=299,403,429
    @rm -r public
