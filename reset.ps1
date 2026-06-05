#Requires -Version 5.1
<#
.SYNOPSIS
    Update OpenDoor and refresh the visitor's Code/ folder with the latest
    handouts. Then launch Claude Code in Code/.

.DESCRIPTION
    Non-destructive:
    1. `git pull --ff-only` on the OpenDoor repo (this script's directory)
       to grab the newest handouts / AGENT.md / CLAUDE.md.
    2. Ensures Code/ exists alongside OpenDoor (creates it if missing).
    3. Copies / overwrites the handouts (`*.md` except README.md) and the
       data files (`*.csv`) into Code/. The previous visitor's own files
       are left untouched - nothing is deleted.
    4. cd's into Code/ and launches the Claude CLI.

.EXAMPLE
    .\reset.ps1
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

# --- Paths ----------------------------------------------------------------
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$CodeDir   = Join-Path $HOME 'src\Code'

Write-Host "ScriptDir : $ScriptDir" -ForegroundColor DarkGray
Write-Host "CodeDir   : $CodeDir"   -ForegroundColor DarkGray

# --- 1. Pull latest OpenDoor ---------------------------------------------
if (Test-Path -LiteralPath (Join-Path $ScriptDir '.git')) {
    if (Get-Command -Name 'git' -ErrorAction SilentlyContinue) {
        Write-Host "Pulling latest OpenDoor ..." -ForegroundColor Cyan
        try {
            git -C $ScriptDir pull --ff-only
            if ($LASTEXITCODE -eq 0) {
                Write-Host "OpenDoor up to date." -ForegroundColor Green
            } else {
                Write-Warning "git pull --ff-only exited with code $LASTEXITCODE. Continuing with current files."
            }
        } catch {
            Write-Warning "git pull failed: $($_.Exception.Message). Continuing with current files."
        }
    } else {
        Write-Warning "git not on PATH - skipping pull."
    }
} else {
    Write-Warning "'$ScriptDir' is not a git repo - skipping pull."
}

# --- 2. Make sure Code/ exists -------------------------------------------
if (-not (Test-Path -LiteralPath $CodeDir -PathType Container)) {
    Write-Host "Creating '$CodeDir' ..." -ForegroundColor Cyan
    $null = New-Item -Path $CodeDir -ItemType Directory -Force
}

# --- 3. Refresh handouts + data files (overwrite, no delete) -------------
# All *.md (incl. CLAUDE.md, AGENTS.md, exercise briefs) except README.md,
# plus all *.csv data files.
$mdFiles  = @(Get-ChildItem -Path $ScriptDir -Filter '*.md'  -File -ErrorAction SilentlyContinue |
              Where-Object { $_.Name -ine 'README.md' })
$csvFiles = @(Get-ChildItem -Path $ScriptDir -Filter '*.csv' -File -ErrorAction SilentlyContinue)
$filesToCopy = @($mdFiles + $csvFiles)

if ($filesToCopy.Count -eq 0) {
    Write-Warning "No .md or .csv files found in '$ScriptDir' to copy."
}
else {
    foreach ($file in $filesToCopy) {
        Copy-Item -LiteralPath $file.FullName -Destination $CodeDir -Force
        Write-Host ("  refreshed  {0}" -f $file.Name) -ForegroundColor DarkGray
    }
    Write-Host ("Refreshed {0} file(s) in '{1}'." -f $filesToCopy.Count, $CodeDir) -ForegroundColor Green
}

Write-Host 'Ready for the next visitor.' -ForegroundColor Cyan

# --- 4. Hand over to Claude CLI in Code/ ---------------------------------
Set-Location -LiteralPath $CodeDir
[System.IO.Directory]::SetCurrentDirectory($CodeDir)

$claudeCmd = Get-Command -Name 'claude' -ErrorAction SilentlyContinue
if ($null -eq $claudeCmd) {
    Write-Warning "Claude CLI not found on PATH. cd-ed into '$CodeDir' - start 'claude' manually."
    exit 0
}

Write-Host "Launching Claude CLI in '$CodeDir' ..." -ForegroundColor Cyan

# Seed an initial prompt so Claude immediately responds with the welcome
# message defined in CLAUDE.md / AGENTS.md (instead of silently waiting
# for the visitor to type something first).
$initialPrompt = 'Hallo'
$cmdLine = 'cd /d "{0}" && claude "{1}"' -f $CodeDir, $initialPrompt
& cmd.exe /c $cmdLine
