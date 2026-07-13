<#
.SYNOPSIS
    Preview the Jekyll site locally with Docker Desktop (live-reload at localhost:8080).
.DESCRIPTION
    Default: uses the prebuilt al-folio image (docker-compose.yml) — fast, no local build.
    -Build : builds the image from the local Dockerfile (docker-local.yml) — use after Gemfile changes.
.EXAMPLE
    ./bin/preview.ps1
.EXAMPLE
    ./bin/preview.ps1 -Build -Port 4000
#>
param(
    [switch]$Build,
    [int]$Port = 8080
)

$ErrorActionPreference = 'Stop'

# Always run from the repo root (parent of this script's bin/ folder).
$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

# Verify Docker is available and the engine is running.
$docker = Get-Command docker -ErrorAction SilentlyContinue
if (-not $docker) {
    Write-Host "Docker is not installed or not on PATH." -ForegroundColor Red
    Write-Host "Install Docker Desktop: https://www.docker.com/products/docker-desktop/"
    exit 1
}
try {
    docker info *> $null
    if ($LASTEXITCODE -ne 0) { throw }
} catch {
    Write-Host "Docker Desktop is installed but the engine isn't running." -ForegroundColor Yellow
    Write-Host "Open Docker Desktop, wait for 'Engine running', then re-run this script."
    exit 1
}

# Gemfile.lock is git-ignored; remove it so the container resolves gems cleanly.
if (Test-Path "$repoRoot/Gemfile.lock") { Remove-Item "$repoRoot/Gemfile.lock" -Force }

$compose = if ($Build) { 'docker-local.yml' } else { 'docker-compose.yml' }
Write-Host "Starting preview with $compose on port $Port ..." -ForegroundColor Cyan
Write-Host "Open http://localhost:$Port  (Ctrl+C to stop)" -ForegroundColor Green

$env:JEKYLL_PORT = "$Port"   # honored only if compose files are parameterized; default is 8080

if ($Build) {
    docker compose -f $compose up --build
} else {
    docker compose -f $compose up
}
