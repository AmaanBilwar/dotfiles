# Stops the Kanata process started by kanata-on.ps1.
$ErrorActionPreference = 'Stop'

$pidFile = Join-Path $PSScriptRoot 'kanata.pid'

if (-not (Test-Path -LiteralPath $pidFile)) {
    Write-Host 'Kanata is not running (no PID file found).'
    return
}

$kanataPid = (Get-Content -LiteralPath $pidFile -Raw).Trim()
$process = Get-Process -Id $kanataPid -ErrorAction SilentlyContinue
if ($process) {
    Stop-Process -Id $kanataPid -Force
    Write-Host "Kanata stopped (PID $kanataPid)."
}
else {
    Write-Host 'Kanata was not running.'
}

Remove-Item -LiteralPath $pidFile -Force
