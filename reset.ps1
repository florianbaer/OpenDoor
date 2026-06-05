#Requires -Version 5.1
<#
.SYNOPSIS
    Reset the Marktstand workspace for the next visitor.

.DESCRIPTION
    1. Deletes the 'Code' directory next to this script (where the previous
       visitor's Advent-of-Code experiments live).
    2. Recreates 'Code' empty.
    3. Copies all *.md handouts and *.csv data files from this script's
       directory into 'Code', so the next visitor has the briefs and data
       ready to go.
    4. cd's into 'Code' and launches the Claude CLI for the next visitor.

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
Set-StrictMode -Version Latest

[string]$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
# Code/ lives next to the OpenDoor/ repo (see Setup-OhMyPosh.ps1: $HOME/src/Code).
[string]$CodeDir   = Resolve-Path -LiteralPath (Join-Path $ScriptDir '..\Code') -ErrorAction SilentlyContinue
if ($null -eq $CodeDir) {
    # Fallback: create it where Setup-OhMyPosh.ps1 would have put it.
    [string]$CodeDir = Join-Path (Split-Path -Parent $ScriptDir) 'Code'
}
else {
    [string]$CodeDir = $CodeDir.Path
}

# --- Confirm ---
if (-not $Force) {
    [string]$reply = Read-Host "Reset '$CodeDir' for the next visitor? (y/N)"
    if ($reply -notin @('y', 'Y', 'yes', 'Yes')) {
        Write-Host 'Aborted.' -ForegroundColor Yellow
        exit 0
    }
}

# --- Wipe ---
if (Test-Path -Path $CodeDir -PathType Container) {
    try {
        Remove-Item -Path $CodeDir -Recurse -Force
        Write-Host "Removed '$CodeDir'." -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to remove '$CodeDir': $_"
        exit 1
    }
}

# --- Recreate ---
New-Item -Path $CodeDir -ItemType Directory -Force | Out-Null

# --- Seed with handouts + data ---
[System.IO.FileInfo[]]$filesToCopy = @(
    Get-ChildItem -Path $ScriptDir -Filter '*.md'  -File
    Get-ChildItem -Path $ScriptDir -Filter '*.csv' -File
)

if ($filesToCopy.Count -eq 0) {
    Write-Warning "No .md or .csv files found in '$ScriptDir' to seed."
}
else {
    foreach ($file in $filesToCopy) {
        Copy-Item -Path $file.FullName -Destination $CodeDir -Force
    }
    Write-Host ("Copied {0} file(s) into '{1}'." -f $filesToCopy.Count, $CodeDir) -ForegroundColor Green
}

Write-Host 'Ready for the next visitor.' -ForegroundColor Cyan

# --- Hand over to Claude CLI in the Code directory ---
Set-Location -Path $CodeDir

[System.Management.Automation.CommandInfo]$claudeCmd =
    Get-Command -Name 'claude' -ErrorAction SilentlyContinue

if ($null -eq $claudeCmd) {
    Write-Warning "Claude CLI not found on PATH. cd-ed into '$CodeDir' — start it manually."
    exit 0
}

Write-Host "Launching Claude CLI in '$CodeDir' ..." -ForegroundColor Cyan
& $claudeCmd.Source
