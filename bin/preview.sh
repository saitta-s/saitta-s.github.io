#!/usr/bin/env bash
#
# Preview the Jekyll site locally without Docker (WSL / Linux / macOS).
# Live-reload dev server at http://localhost:<port> (default 4000).
#
# Usage:
#   ./bin/preview.sh                 # serve with live reload on port 4000
#   ./bin/preview.sh -p 8080         # use a different port
#   ./bin/preview.sh --no-livereload # disable live reload
#
# One-time system deps (Debian/Ubuntu/WSL):
#   sudo apt install -y ruby-full build-essential imagemagick \
#        libmagickwand-dev zlib1g-dev nodejs
#   gem install --user-install bundler
#
# Everything stays local; the live site only updates on push to master.

set -euo pipefail

PORT=4000
LIVERELOAD="--livereload"

while [[ $# -gt 0 ]]; do
  case "$1" in
    -p|--port)        PORT="$2"; shift 2 ;;
    --no-livereload)  LIVERELOAD=""; shift ;;
    -h|--help)        sed -n '2,20p' "$0"; exit 0 ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

# Always run from the repo root (parent of this script's bin/ folder).
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

# Warn early if the toolchain is missing.
if ! command -v ruby >/dev/null 2>&1; then
  echo "Ruby is not installed. On Debian/Ubuntu/WSL run:" >&2
  echo "  sudo apt install -y ruby-full build-essential imagemagick libmagickwand-dev zlib1g-dev nodejs" >&2
  exit 1
fi
if ! command -v bundle >/dev/null 2>&1; then
  echo "Bundler is not installed. Run: gem install --user-install bundler" >&2
  echo "(then add \"\$(ruby -e 'puts Gem.user_dir')/bin\" to your PATH)" >&2
  exit 1
fi

# Gemfile.lock is git-ignored; drop it so gems resolve cleanly for this platform.
rm -f Gemfile.lock

# Install gems on first run (or after Gemfile changes); cached thereafter.
if ! bundle check >/dev/null 2>&1; then
  echo "Installing gems (first run is slow, then cached) ..."
  bundle install
fi

echo "Serving on http://localhost:${PORT}  (Ctrl+C to stop)"
exec bundle exec jekyll serve ${LIVERELOAD} --host 0.0.0.0 --port "${PORT}"
