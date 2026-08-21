# Starts Kanata with this stowed configuration.
$ErrorActionPreference = 'Stop'

# Strip PowerShell provider prefix before passing path to kanata.exe.
# Kanata accepts native paths such as \\wsl.localhost\Ubuntu-24.04\..., not
# `Microsoft.PowerShell.Core\\FileSystem::...` paths.
$configPsPath = Join-Path $PSScriptRoot 'config.kbd'
$config = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($configPsPath)
$pidFile = Join-Path $PSScriptRoot 'kanata.pid'

# Prefer WSL/dotfiles copy when reachable so Windows ~/.config does not drift.
$dotfilesConfig = '\\wsl$\Ubuntu-24.04\home\amaan\projects\dotfiles\kanata\.config\kanata\config.kbd'
if (Test-Path -LiteralPath $dotfilesConfig) {
    # Previous behavior copied unconditionally, which can corrupt the file when
    # source and destination resolve to the same WSL file.
    # Copy-Item -LiteralPath $dotfilesConfig -Destination $config -Force
    $needsSync = -not (Test-Path -LiteralPath $config) -or
        (Get-FileHash -LiteralPath $dotfilesConfig).Hash -ne
        (Get-FileHash -LiteralPath $config).Hash

    if ($needsSync) {
        Copy-Item -LiteralPath $dotfilesConfig -Destination $config -Force
        Write-Host "Synced config from dotfiles."
    }
}

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
