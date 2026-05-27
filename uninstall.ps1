# PowerShell script to uninstall ACC Copilot agents from VS Code global storage
# Usage: Run this script from anywhere.

$ErrorActionPreference = 'Stop'

$copilotGlobalRoot = Join-Path $env:APPDATA 'Code\User\globalStorage\github.copilot-chat'
$accGlobalRoot = Join-Path $copilotGlobalRoot 'acc-agents'

if (-not (Test-Path $accGlobalRoot)) {
    Write-Host "[ACC Agents Uninstaller] Nothing to remove. Path not found: $accGlobalRoot"
    exit 0
}

Write-Host "[ACC Agents Uninstaller] Removing global ACC agents from: $accGlobalRoot"
Remove-Item -Path $accGlobalRoot -Recurse -Force

Write-Host '[ACC Agents Uninstaller] Uninstall complete.'
Write-Host '[ACC Agents Uninstaller] Restart VS Code to refresh the global agent list.'
