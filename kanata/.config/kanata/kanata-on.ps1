# Starts Kanata with this stowed configuration.
$ErrorActionPreference = 'Stop'

$config = Join-Path $PSScriptRoot 'config.kbd'
$pidFile = Join-Path $PSScriptRoot 'kanata.pid'

if (-not (Test-Path -LiteralPath $config)) {
    throw "Kanata configuration was not found: $config"
}

if (Test-Path -LiteralPath $pidFile) {
    $existingPid = Get-Content -LiteralPath $pidFile -Raw
    $existing = Get-Process -Id $existingPid.Trim() -ErrorAction SilentlyContinue
    if ($existing) {
        Write-Host "Kanata is already running (PID $($existing.Id))."
        return
    }
    Remove-Item -LiteralPath $pidFile -Force
}

$kanata = (Get-Command kanata.exe -ErrorAction Stop).Source
$process = Start-Process -FilePath $kanata -ArgumentList @('--cfg', $config, '--no-wait', '--quiet') -WindowStyle Hidden -PassThru
$process.Id | Set-Content -LiteralPath $pidFile -NoNewline
Write-Host "Kanata started (PID $($process.Id)) using $config"
