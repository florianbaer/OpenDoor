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

# --- Pull latest OpenDoor (so newest handouts get seeded) ----------------
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
        Write-Warning "git not on PATH - skipping pull. Continuing with current files."
    }
} else {
    Write-Warning "'$ScriptDir' is not a git repo - skipping pull."
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
# Copy ALL *.md files (exercise briefs + AGENT.md + CLAUDE.md) and *.csv
# data files. Only README.md is skipped - that one is for the booth
# operator, not the visitor.
$mdFiles  = @(Get-ChildItem -Path $ScriptDir -Filter '*.md'  -File -ErrorAction SilentlyContinue |
              Where-Object { $_.Name -ine 'README.md' })
$csvFiles = @(Get-ChildItem -Path $ScriptDir -Filter '*.csv' -File -ErrorAction SilentlyContinue)
$filesToCopy = @($mdFiles + $csvFiles)

if ($filesToCopy.Count -eq 0) {
    Write-Warning "No .md or .csv files found in '$ScriptDir' to seed."
}
else {
    foreach ($file in $filesToCopy) {
        Copy-Item -LiteralPath $file.FullName -Destination $CodeDir -Force
        Write-Host ("  copied  {0}" -f $file.Name) -ForegroundColor DarkGray
    }
    Write-Host ("Copied {0} file(s) into '{1}'." -f $filesToCopy.Count, $CodeDir) -ForegroundColor Green
}

Write-Host 'Ready for the next visitor.' -ForegroundColor Cyan

# --- Hand over to Claude CLI in the Code directory -----------------------
# Align PowerShell location, .NET process cwd, AND environment so any
# wrapper/shim sees the same value.
Set-Location -LiteralPath $CodeDir
[System.IO.Directory]::SetCurrentDirectory($CodeDir)
[Environment]::CurrentDirectory = $CodeDir
$env:PWD  = $CodeDir
$env:INIT_CWD = $CodeDir

$claudeCmd = Get-Command -Name 'claude' -ErrorAction SilentlyContinue
if ($null -eq $claudeCmd) {
    Write-Warning "Claude CLI not found on PATH. cd-ed into '$CodeDir' - start it manually."
    exit 0
}

Write-Host '--- Claude launch diagnostics ---'                       -ForegroundColor DarkGray
Write-Host "Claude command type : $($claudeCmd.CommandType)"          -ForegroundColor DarkGray
Write-Host "Claude source       : $($claudeCmd.Source)"               -ForegroundColor DarkGray
Write-Host "PowerShell location : $((Get-Location).Path)"             -ForegroundColor DarkGray
Write-Host "Process cwd (.NET)  : $([System.IO.Directory]::GetCurrentDirectory())" -ForegroundColor DarkGray
Write-Host '---------------------------------'                        -ForegroundColor DarkGray

Write-Host "Launching Claude CLI in '$CodeDir' ..." -ForegroundColor Cyan

# Invoke claude through cmd.exe with an explicit `cd /d`. cmd inherits its
# cwd from us (which we've now aligned), but `cd /d` makes the working
# directory of the child process completely unambiguous, including the
# drive letter. We pass $CodeDir again as an argument in case the CLI
# treats a positional path as the project directory.
$cmdLine = 'cd /d "{0}" && claude "{0}"' -f $CodeDir
& cmd.exe /c $cmdLine
