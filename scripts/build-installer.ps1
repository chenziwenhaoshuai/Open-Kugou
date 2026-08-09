$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$isccCandidates = @(
  (Join-Path ${env:ProgramFiles(x86)} 'Inno Setup 6\ISCC.exe'),
  (Join-Path ${env:ProgramFiles} 'Inno Setup 6\ISCC.exe'),
  (Join-Path ${env:LOCALAPPDATA} 'Programs\Inno Setup 6\ISCC.exe')
)
$iscc = $isccCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1

if (-not $iscc) {
  throw 'Inno Setup 6 ISCC.exe was not found. Install Inno Setup 6, then rerun npm run installerwin.'
}

$exe = Join-Path $root 'bin\app_win.exe'
if (-not (Test-Path $exe)) {
  throw "Windows executable not found: $exe"
}

New-Item -ItemType Directory -Force (Join-Path $root 'dist') | Out-Null
& $iscc (Join-Path $root 'installer.iss')
if ($LASTEXITCODE -ne 0) {
  throw "Inno Setup failed with exit code $LASTEXITCODE"
}

Write-Host "Installer created under $(Join-Path $root 'dist')"
