default:
    @just --list

watch:
    @tailwindcss -i static/css/_style.css -o static/css/style.css --watch

css:
    @tailwindcss -i static/css/_style.css -o static/css/style.css

serve:
    @zola serve
