$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$output = Join-Path $env:TEMP 'open-kugou-desktop-output'
$finalOutput = Join-Path $root 'desktop-app-source'
$staging = Join-Path $env:TEMP 'open-kugou-desktop-source'
Remove-Item $output -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item $finalOutput -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item $staging -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force $staging | Out-Null
Get-ChildItem $root -Force | Where-Object { $_.Name -notin @('.git','dist','dist-desktop','dist-desktop-app','dist-desktop-final','dist-electron-unique','bin') } | Copy-Item -Destination $staging -Recurse -Force
Push-Location $staging
try {
  & (Join-Path $root 'node_modules\.bin\electron-packager.cmd') '.' 'Open-Kugou' '--platform=win32' '--arch=x64' "--out=$output" '--overwrite' '--prune=true' '--app-version=1.6.0' '--electron-version=43.3.0'
  if ($LASTEXITCODE -ne 0) { throw "electron-packager failed with exit code $LASTEXITCODE" }
  New-Item -ItemType Directory -Force $finalOutput | Out-Null
  Copy-Item (Join-Path $output 'Open-Kugou-win32-x64') $finalOutput -Recurse -Force
} finally { Pop-Location }
