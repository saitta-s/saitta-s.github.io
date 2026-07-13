# Previewing the site locally

This site is built with Jekyll (al-folio theme). The theme's dependencies
(`jekyll-scholar`, `mini_racer`, `imagemagick`, …) are painful to install
natively on Windows. Two reliable ways to preview on this machine:

- **WSL (Ubuntu)** — no Docker; run Jekyll directly inside WSL. See
  [Option A](#option-a--wsl-ubuntu-no-docker).
- **Docker Desktop** — build/serve in a container. See
  [Option B](#option-b--docker-desktop).

Either way, nothing is published.

> Everything stays on the `site-refresh` branch and on your machine.
> The live site only updates when changes are pushed to `master`.

## Option A — WSL (Ubuntu, no Docker)

One-time system deps (inside an Ubuntu terminal):

```bash
sudo apt update
sudo apt install -y ruby-full build-essential imagemagick \
     libmagickwand-dev zlib1g-dev nodejs
gem install --user-install bundler
```

Then, every time, from the repo root:

```bash
./bin/preview.sh          # live-reload dev server on http://localhost:4000
./bin/preview.sh -p 8080  # use a different port
```

The helper drops the git-ignored `Gemfile.lock`, runs `bundle install` on the
first run (cached after), and serves with live reload. Press **Ctrl+C** to stop.

> Serving from `/mnt/c/...` works but file-watching can be sluggish. For faster
> reloads, `git clone` the repo into your WSL home (`~/`) and serve from there.

## Option B — Docker Desktop

## One-time setup

1. Install **Docker Desktop for Windows**: https://www.docker.com/products/docker-desktop/
   (Use the WSL 2 backend when prompted — it's the default.)
2. Launch Docker Desktop and wait until it says **"Engine running"**.

## Preview (every time)

From the repo root in PowerShell:

```powershell
./bin/preview.ps1
```

Then open **http://localhost:8080** in your browser.

- The site **live-reloads**: edit a file, save, and the browser refreshes.
- Press **Ctrl+C** in the terminal to stop.

### What the helper does

By default it uses the prebuilt al-folio image (fastest, no local build):

```powershell
docker compose -f docker-compose.yml up
```

If you ever change the `Gemfile` and need a from-source build, run:

```powershell
./bin/preview.ps1 -Build      # uses docker-local.yml (builds the image once)
```

### Manual fallback (no helper script)

```powershell
# prebuilt image
docker compose -f docker-compose.yml up
# or build from source
docker compose -f docker-local.yml up --build
```

## Troubleshooting

- **"docker: command not found" / engine not running** — open Docker Desktop
  first and wait for "Engine running".
- **Port 8080 already in use** — run `./bin/preview.ps1 -Port 4000` and open
  http://localhost:4000.
- **Stale build / weird errors** — delete `Gemfile.lock` and `_site/` (both are
  git-ignored) and re-run.
- **First run is slow** — it pulls the image / builds gems once, then caches.
