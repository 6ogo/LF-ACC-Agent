# PowerShell script to install ACC Copilot agents globally (user-scoped)
# Usage: Run this script from the LF-ACC-Agent repo root after cloning LF-ACC-Wiki as a sibling.

$ErrorActionPreference = 'Stop'

function Copy-AgentFile {
    param(
        [Parameter(Mandatory = $true)][string]$SourceFile,
        [Parameter(Mandatory = $true)][string]$DestinationFile,
        [string]$WikiUriPrefix
    )

    $content = Get-Content -Path $SourceFile -Raw

    if ($WikiUriPrefix) {
        # Agent files currently reference ../../../LF-ACC-Wiki/. Rewrite to absolute file URI so it works globally.
        $content = $content -replace '\.\./\.\./\.\./LF-ACC-Wiki/', $WikiUriPrefix
    }

    Set-Content -Path $DestinationFile -Value $content -Encoding UTF8
}

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$sourceAgentsDir = Join-Path $repoRoot '.github\agents'

if (-not (Test-Path $sourceAgentsDir)) {
    Write-Error "[ACC Agents Installer] Source agents folder not found: $sourceAgentsDir"
    exit 1
}

$copilotGlobalRoot = Join-Path $env:APPDATA 'Code\User\globalStorage\github.copilot-chat'
$accGlobalRoot = Join-Path $copilotGlobalRoot 'acc-agents'

New-Item -ItemType Directory -Path $accGlobalRoot -Force | Out-Null

$wikiRepoPath = Join-Path $repoRoot '..\LF-ACC-Wiki'
$wikiUriPrefix = $null
if (Test-Path $wikiRepoPath) {
    $resolvedWikiPath = (Resolve-Path $wikiRepoPath).Path
    $wikiUriPrefix = ((New-Object System.Uri(($resolvedWikiPath + [System.IO.Path]::DirectorySeparatorChar))).AbsoluteUri)
    Write-Host "[ACC Agents Installer] Found wiki at: $resolvedWikiPath"
} else {
    Write-Warning "[ACC Agents Installer] LF-ACC-Wiki not found as sibling. Installing agents anyway, but wiki links may not resolve."
}

Write-Host "[ACC Agents Installer] Installing global Copilot agents to: $accGlobalRoot"

$agentFiles = Get-ChildItem -Path $sourceAgentsDir -Filter '*.agent.md' -File
if (-not $agentFiles) {
    Write-Error '[ACC Agents Installer] No .agent.md files found in source folder.'
    exit 1
}

foreach ($agent in $agentFiles) {
    $folderName = [System.IO.Path]::GetFileNameWithoutExtension($agent.Name)
    if ($folderName.EndsWith('.agent')) {
        $folderName = $folderName.Substring(0, $folderName.Length - '.agent'.Length)
    }

    $targetDir = Join-Path $accGlobalRoot $folderName
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null

    $targetFile = Join-Path $targetDir $agent.Name
    Copy-AgentFile -SourceFile $agent.FullName -DestinationFile $targetFile -WikiUriPrefix $wikiUriPrefix

    Write-Host "  - Installed $($agent.Name)"
}

Write-Host '[ACC Agents Installer] Installation complete.'
Write-Host '[ACC Agents Installer] Restart VS Code to refresh the global agent list.'
