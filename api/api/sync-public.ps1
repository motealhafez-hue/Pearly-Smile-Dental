# Sync static site from monorepo parent into api/public for api-only Git / Render deploy.
# Run from api/:  powershell -ExecutionPolicy Bypass -File .\sync-public.ps1
# Optional:  .\sync-public.ps1 -SiteRoot "C:\path\to\full\site"

param(
    [string] $SiteRoot = ""
)

$ErrorActionPreference = "Stop"
$ApiDir = $PSScriptRoot
if (-not $SiteRoot) {
    $SiteRoot = (Resolve-Path (Join-Path $ApiDir "..")).Path
}
$Pub = Join-Path $ApiDir "public"
$Index = Join-Path $SiteRoot "index.html"
if (-not (Test-Path $Index)) {
    Write-Error "No index.html at $SiteRoot. Pass -SiteRoot path to your full project."
}
if (Test-Path $Pub) {
    Remove-Item $Pub -Recurse -Force
}
New-Item -ItemType Directory -Path $Pub | Out-Null

# Root-level *.css / *.js includes minified bundles (e.g. style.min.css, script.min.js).
Get-ChildItem -Path $SiteRoot -File | ForEach-Object {
    $ext = $_.Extension.ToLowerInvariant()
    if ($ext -in @(".html", ".css", ".js", ".txt", ".xml")) {
        Copy-Item $_.FullName -Destination $Pub -Force
    }
}
$Pictures = Join-Path $SiteRoot "Pictures"
if (Test-Path $Pictures) {
    Copy-Item $Pictures (Join-Path $Pub "Pictures") -Recurse -Force
}
Write-Host "Synced $SiteRoot -> $Pub"
