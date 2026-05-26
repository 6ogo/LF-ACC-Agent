# PowerShell script to build and install the ACC Agents VS Code extension globally
# Usage: Run this script from the project root after cloning

# Ensure script stops on error
$ErrorActionPreference = 'Stop'

Write-Host "[ACC Agents Installer] Installing dependencies..."
npm install

Write-Host "[ACC Agents Installer] Building extension (if build script exists)..."
if (Test-Path package.json) {
    $pkg = Get-Content package.json | ConvertFrom-Json
    if ($pkg.scripts.build) {
        npm run build
    }
}

Write-Host "[ACC Agents Installer] Packaging extension..."
if (-not (Get-Command vsce -ErrorAction SilentlyContinue)) {
    Write-Host "[ACC Agents Installer] Installing vsce (VS Code Extension Manager)..."
    npm install -g vsce
}

vsce package

$vsix = Get-ChildItem *.vsix | Select-Object -First 1
if (-not $vsix) {
    Write-Error "[ACC Agents Installer] No .vsix package found. Packaging failed."
    exit 1
}

Write-Host "[ACC Agents Installer] Installing extension globally..."
code --install-extension $vsix.FullName

Write-Host "[ACC Agents Installer] Installation complete!"
