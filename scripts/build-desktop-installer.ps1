$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$isccCandidates = @(
  (Join-Path ${env:ProgramFiles(x86)} 'Inno Setup 6\ISCC.exe'),
  (Join-Path ${env:ProgramFiles} 'Inno Setup 6\ISCC.exe'),
  (Join-Path ${env:LOCALAPPDATA} 'Programs\Inno Setup 6\ISCC.exe')
)
$iscc = $isccCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $iscc) { throw 'Inno Setup 6 ISCC.exe was not found.' }
$appDir = Join-Path $root 'desktop-app-source\Open-Kugou-win32-x64'
if (-not (Test-Path (Join-Path $appDir 'Open-Kugou.exe'))) { throw "Desktop app not found: $appDir" }
New-Item -ItemType Directory -Force (Join-Path $root 'dist-desktop-final') | Out-Null
& $iscc (Join-Path $root 'desktop-installer.iss')
if ($LASTEXITCODE -ne 0) { throw "Inno Setup failed with exit code $LASTEXITCODE" }
