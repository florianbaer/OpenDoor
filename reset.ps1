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

    Runs without confirmation - intended to be triggered between visitors
    by the booth operator.

.EXAMPLE
    .\reset.ps1
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

# --- Paths ----------------------------------------------------------------
# Resolve script location for finding *.md / *.csv source files.
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Code/ lives at $HOME\src\Code (created by Setup-OhMyPosh.ps1).
# Use an absolute path here so reset works regardless of where the script
# is invoked from.
$CodeDir = Join-Path $HOME 'src\Code'

Write-Host "ScriptDir : $ScriptDir" -ForegroundColor DarkGray
Write-Host "CodeDir   : $CodeDir"   -ForegroundColor DarkGray
Write-Host "Resetting '$CodeDir' for the next visitor ..." -ForegroundColor Cyan

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
# Copy all *.md (exercise briefs + AGENT.md) and *.csv data files, but
# skip README.md — that one is for the booth operator, not the visitor.
$mdFiles  = @(Get-ChildItem -Path $ScriptDir -Filter '*.md'  -File -ErrorAction SilentlyContinue |
              Where-Object { $_.Name -ne 'README.md' })
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
Write-Host "Current directory: $(Get-Location)" -ForegroundColor DarkGray

$claudeCmd = Get-Command -Name 'claude' -ErrorAction SilentlyContinue

if ($null -eq $claudeCmd) {
    Write-Warning "Claude CLI not found on PATH. cd-ed into '$CodeDir' - start it manually."
    exit 0
}

Write-Host "Launching Claude CLI in '$CodeDir' ..." -ForegroundColor Cyan
# Use Start-Process with explicit -WorkingDirectory so the child process
# inherits the Code directory even if the wrapper would otherwise default
# to its own location.
Start-Process -FilePath $claudeCmd.Source -WorkingDirectory $CodeDir -NoNewWindow -Wait
