# Stops the Kanata process started by kanata-on.ps1.
$ErrorActionPreference = 'Stop'

$pidFile = Join-Path $PSScriptRoot 'kanata.pid'

if (-not (Test-Path -LiteralPath $pidFile)) {
    Write-Host 'Kanata is not running (no PID file found).'
    return
}

$kanataPidText = (Get-Content -LiteralPath $pidFile -Raw).Trim()
$kanataPid = 0
$validPid = [int]::TryParse($kanataPidText, [ref]$kanataPid)
$process = if ($validPid -and $kanataPid -gt 0) {
    Get-Process -Id $kanataPid -ErrorAction SilentlyContinue
}

if ($process -and $process.ProcessName -ieq 'kanata') {
    # The process can exit between Get-Process and Stop-Process during startup.
    Stop-Process -Id $kanataPid -Force -ErrorAction SilentlyContinue
    Write-Host "Kanata stopped (PID $kanataPid)."
}
elseif ($process) {
    Write-Host "PID $kanataPid is not Kanata; leaving it running."
}
elseif ($validPid) {
    Write-Host 'Kanata was not running.'
}
else {
    Write-Host 'Kanata PID file was invalid.'
}

Remove-Item -LiteralPath $pidFile -Force
