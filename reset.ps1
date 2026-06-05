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

# --- Safety guards: never wipe the OpenDoor repo itself -------------------
# Normalise paths for comparison (trailing slash, case).
function _Norm([string]$p) {
    if ([string]::IsNullOrWhiteSpace($p)) { return '' }
    try { return ([System.IO.Path]::GetFullPath($p)).TrimEnd('\','/').ToLowerInvariant() }
    catch { return $p.TrimEnd('\','/').ToLowerInvariant() }
}

$normCode    = _Norm $CodeDir
$normScript  = _Norm $ScriptDir

if ([string]::IsNullOrWhiteSpace($normCode)) {
    Write-Error "CodeDir resolved to empty - aborting to avoid disaster."
    exit 1
}
if ($normCode -eq $normScript) {
    Write-Error "CodeDir equals OpenDoor ('$ScriptDir') - refusing to delete the repo."
    exit 1
}
if ($normScript.StartsWith($normCode + '\') -or $normScript.StartsWith($normCode + '/')) {
    Write-Error "OpenDoor ('$ScriptDir') sits inside CodeDir ('$CodeDir') - refusing to delete (would nuke the repo)."
    exit 1
}
if ((Split-Path -Leaf $normCode) -ne 'code') {
    Write-Error "CodeDir basename is not 'Code' ('$CodeDir') - aborting as a safety check."
    exit 1
}

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

# --- Stop any lingering Claude processes ---------------------------------
# A claude process from the previous visitor will hold file locks inside
# Code/ and make Remove-Item fail. Kill it before wiping.
$claudeProcs = @(Get-Process -Name 'claude' -ErrorAction SilentlyContinue) +
               @(Get-Process -Name 'claude-code' -ErrorAction SilentlyContinue)
foreach ($proc in $claudeProcs) {
    try {
        Stop-Process -Id $proc.Id -Force -ErrorAction Stop
        Write-Host ("Stopped lingering process: {0} (PID {1})." -f $proc.ProcessName, $proc.Id) -ForegroundColor Yellow
    } catch {
        Write-Warning ("Could not stop process {0} (PID {1}): {2}" -f $proc.ProcessName, $proc.Id, $_.Exception.Message)
    }
}

# Also kill any node.exe whose command line points at claude (npm-installed
# Claude Code shows up as node.exe holding the working directory open).
try {
    $nodeProcs = Get-CimInstance -ClassName Win32_Process -Filter "Name = 'node.exe'" -ErrorAction SilentlyContinue |
                 Where-Object { $_.CommandLine -match 'claude' }
    foreach ($np in $nodeProcs) {
        try {
            Stop-Process -Id $np.ProcessId -Force -ErrorAction Stop
            Write-Host ("Stopped lingering node process (PID {0}) - claude wrapper." -f $np.ProcessId) -ForegroundColor Yellow
        } catch {
            Write-Warning ("Could not stop node PID {0}: {1}" -f $np.ProcessId, $_.Exception.Message)
        }
    }
} catch {
    # CIM not available - skip silently
}

# Move OUT of $CodeDir (in case this shell sits inside it) before delete.
Set-Location -LiteralPath $HOME

# Give Windows a moment to release file handles.
Start-Sleep -Milliseconds 300

# --- Wipe -----------------------------------------------------------------
function Remove-DirRobust {
    param([Parameter(Mandatory)][string]$Path)

    # 1. Quick try.
    try {
        Remove-Item -LiteralPath $Path -Recurse -Force -ErrorAction Stop
        return $true
    } catch {
        Write-Warning "Remove-Item failed: $($_.Exception.Message)"
    }

    # 2. Rename to a temp name, then delete. Renaming often succeeds even
    #    when individual files are locked; the delete can then proceed in
    #    the background.
    $tmpPath = Join-Path (Split-Path -Parent $Path) (".to-delete-{0}" -f ([guid]::NewGuid().ToString('n').Substring(0,8)))
    try {
        Rename-Item -LiteralPath $Path -NewName (Split-Path -Leaf $tmpPath) -ErrorAction Stop
        Write-Host "Renamed locked dir to '$tmpPath', deleting in background ..." -ForegroundColor Yellow
        Start-Job -ScriptBlock {
            param($p)
            for ($i = 0; $i -lt 10; $i++) {
                try { Remove-Item -LiteralPath $p -Recurse -Force -ErrorAction Stop; return } catch { Start-Sleep -Seconds 1 }
            }
        } -ArgumentList $tmpPath | Out-Null
        return $true
    } catch {
        Write-Warning "Rename fallback also failed: $($_.Exception.Message)"
    }

    # 3. Last resort: cmd.exe rmdir, which sometimes copes when PowerShell does not.
    try {
        & cmd.exe /c "rmdir /s /q `"$Path`""
        if (-not (Test-Path -LiteralPath $Path)) { return $true }
    } catch {
        Write-Warning "cmd rmdir failed: $($_.Exception.Message)"
    }

    return -not (Test-Path -LiteralPath $Path)
}

if (Test-Path -LiteralPath $CodeDir -PathType Container) {
    if (Remove-DirRobust -Path $CodeDir) {
        Write-Host "Removed '$CodeDir'." -ForegroundColor Green
    } else {
        Write-Error "Konnte '$CodeDir' nicht loeschen. Wahrscheinlich haelt noch etwas Files offen:"
        Write-Error "  - Windows-Explorer-Fenster auf 'Code' geoeffnet? Schliessen."
        Write-Error "  - VS Code / Editor mit Datei aus Code/ offen? Schliessen."
        Write-Error "  - Anderes PowerShell-Fenster sitzt in 'Code'? 'cd ~' ausfuehren."
        Write-Error "Danach reset.ps1 erneut starten."
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
