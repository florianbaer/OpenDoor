#Requires -Version 5.1
<#
.SYNOPSIS
    Reset the Marktstand workspace for the next visitor.

.DESCRIPTION
    1. Deletes the 'Code' directory (sibling of OpenDoor, i.e. ~/src/Code).
    2. Recreates 'Code' empty.
    3. Copies all *.md handouts and *.csv data files from this script's
       directory into 'Code'.
    4. cd's into 'Code' and launches the Claude CLI.

    Safe to run when 'Code' does not exist yet. Asks for confirmation unless
    -Force is passed.

.PARAMETER Force
    Skip the confirmation prompt.

.EXAMPLE
    .\reset.ps1
    .\reset.ps1 -Force
#>
[CmdletBinding()]
param(
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

# --- Paths ----------------------------------------------------------------
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ParentDir = Split-Path -Parent $ScriptDir
$CodeDir   = Join-Path $ParentDir 'Code'

# --- Confirm --------------------------------------------------------------
if (-not $Force) {
    $reply = Read-Host "Reset '$CodeDir' for the next visitor? (y/N)"
    if ($reply -notin @('y', 'Y', 'yes', 'Yes')) {
        Write-Host 'Aborted.' -ForegroundColor Yellow
        exit 0
    }
}

# --- Wipe -----------------------------------------------------------------
if (Test-Path -LiteralPath $CodeDir -PathType Container) {
    try {
        Remove-Item -LiteralPath $CodeDir -Recurse -Force
        Write-Host "Removed '$CodeDir'." -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to remove '$CodeDir': $_"
        exit 1
    }
}

# --- Recreate -------------------------------------------------------------
$null = New-Item -Path $CodeDir -ItemType Directory -Force

# --- Seed with handouts + data -------------------------------------------
$mdFiles  = @(Get-ChildItem -Path $ScriptDir -Filter '*.md'  -File -ErrorAction SilentlyContinue)
$csvFiles = @(Get-ChildItem -Path $ScriptDir -Filter '*.csv' -File -ErrorAction SilentlyContinue)
$filesToCopy = @($mdFiles + $csvFiles)

if ($filesToCopy.Count -eq 0) {
    Write-Warning "No .md or .csv files found in '$ScriptDir' to seed."
}
else {
    foreach ($file in $filesToCopy) {
        Copy-Item -LiteralPath $file.FullName -Destination $CodeDir -Force
    }
    Write-Host ("Copied {0} file(s) into '{1}'." -f $filesToCopy.Count, $CodeDir) -ForegroundColor Green
}

Write-Host 'Ready for the next visitor.' -ForegroundColor Cyan

# --- Hand over to Claude CLI in the Code directory -----------------------
Set-Location -LiteralPath $CodeDir

$claudeCmd = Get-Command -Name 'claude' -ErrorAction SilentlyContinue

if ($null -eq $claudeCmd) {
    Write-Warning "Claude CLI not found on PATH. cd-ed into '$CodeDir' - start it manually."
    exit 0
}

Write-Host "Launching Claude CLI in '$CodeDir' ..." -ForegroundColor Cyan
& $claudeCmd.Source
