# Previewing the site locally

This site is built with Jekyll (al-folio theme). The theme's dependencies
(`jekyll-scholar`, `mini_racer`, `imagemagick`, …) are painful to install
natively on Windows, so the reliable way to preview on this machine is
**Docker Desktop**. You build/serve in a container; nothing is published.

> Everything stays on the `site-refresh` branch and on your machine.
> The live site only updates when changes are pushed to `master`.

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
