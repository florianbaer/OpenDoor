#Requires -Version 5.1
<#
.SYNOPSIS
    Installiert Oh My Posh + Fira Code Nerd Font + Claude Code via winget,
    richtet die PowerShell-Profile fuer Autostart ein und setzt die Schriftart
    in Windows Terminal.

.NOTES
    In einer NORMALEN (nicht-elevated) PowerShell ausfuehren.

    AUSFUEHRUNG (falls "ist nicht digital signiert" / ExecutionPolicy-Fehler):
        powershell -ExecutionPolicy Bypass -File .\Setup-OhMyPosh.ps1
    Das Skript hebt die Policy zudem unten automatisch fuer die eigene
    Session auf und entfernt die Internet-Markierung (Mark-of-the-Web).

    oh-my-posh kennt nur den Shell-Identifier 'pwsh' - dieser gilt sowohl
    fuer Windows PowerShell 5.1 als auch fuer PowerShell 7. Die Profile nutzen
    die '--eval'-Variante, damit der Prompt auch dann laedt, wenn unsignierte
    lokale Profilskripte durch die ExecutionPolicy blockiert werden.
#>

[CmdletBinding()]
param()

# --- Execution-Policy fuer DIESE Session erlauben -------------------------
# Hebt restriktive Policies (RemoteSigned/AllSigned/Restricted) nur fuer den
# laufenden Prozess auf und entfernt die "aus dem Internet"-Markierung.
try { Unblock-File -LiteralPath $PSCommandPath -ErrorAction SilentlyContinue } catch {}
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force -ErrorAction SilentlyContinue

# WICHTIG: Damit das Profil auch in KUENFTIGEN Sessions geladen wird, muss die
# dauerhafte Policy lokale Skripte erlauben. RemoteSigned laesst lokal erstellte
# Profile laufen (nur aus dem Internet geladene Skripte muessen signiert sein).
$cur = Get-ExecutionPolicy -Scope CurrentUser
if ($cur -in 'Restricted','AllSigned','Undefined') {
    try {
        Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
        Write-Host "ExecutionPolicy (CurrentUser) auf RemoteSigned gesetzt." -ForegroundColor Green
    } catch {
        Write-Warning "Konnte CurrentUser-Policy nicht setzen (evtl. per Gruppenrichtlinie erzwungen): $($_.Exception.Message)"
    }
}

$ErrorActionPreference = 'Stop'

function Write-Step { param([string]$Message) Write-Host "`n==> $Message" -ForegroundColor Cyan }

# --- 0. Voraussetzungen pruefen -------------------------------------------
Write-Step 'Pruefe winget...'
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw "winget wurde nicht gefunden. Bitte 'App Installer' aus dem Microsoft Store installieren."
}

# --- 1. Oh My Posh via winget ---------------------------------------------
Write-Step 'Installiere Oh My Posh...'
winget install --id JanDeDobbeleer.OhMyPosh --source winget `
    --accept-package-agreements --accept-source-agreements --silent

# winget aktualisiert die PATH-Variable erst in neuer Session.
# Daher den Installationspfad fuer DIESE Session manuell ergaenzen.
$ompPath = Join-Path $env:LOCALAPPDATA 'Programs\oh-my-posh\bin'
if (Test-Path $ompPath) { $env:Path = "$ompPath;$env:Path" }

if (-not (Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
    Write-Warning "oh-my-posh ist in dieser Session noch nicht im PATH. Font-Install ggf. nach Neustart der Shell ausfuehren."
}

# --- 2. Fira Code Nerd Font installieren ----------------------------------
Write-Step 'Installiere Fira Code Nerd Font...'
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    # Als normaler Benutzer wird automatisch in das Benutzer-Font-Verzeichnis installiert
    oh-my-posh font install FiraCode
} else {
    Write-Warning 'Font-Installation uebersprungen (oh-my-posh nicht verfuegbar).'
}

# --- 3. PowerShell-Profile fuer Autostart einrichten ----------------------
# Legt das Standard-Profil (CurrentUserCurrentHost) fuer Windows PowerShell 5.1
# UND PowerShell 7 an und ergaenzt die Init-Zeile, falls sie fehlt.
Write-Step 'Richte PowerShell-Profile ein...'

$initLine = 'oh-my-posh init pwsh | Invoke-Expression'
$block    = "`n# Oh My Posh Autostart`n$initLine`n"

# Logging: was genau wird geschrieben?
Write-Host ("initLine   : [{0}]" -f $initLine)        -ForegroundColor DarkCyan
Write-Host ("initLine.Length: {0}" -f $initLine.Length) -ForegroundColor DarkCyan
if ([string]::IsNullOrWhiteSpace($initLine)) {
    throw 'FEHLER: $initLine ist leer - es gibt nichts zu schreiben.'
}

function Set-OmpProfile {
    param([Parameter(Mandatory)][string]$ProfilePath)
    try {
        Write-Host "`n--- Profil: $ProfilePath ---" -ForegroundColor Cyan
        $dir = Split-Path -Parent $ProfilePath
        if ($dir -and -not (Test-Path -LiteralPath $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
            Write-Host "Verzeichnis erstellt: $dir" -ForegroundColor DarkGray
        }
        if (-not (Test-Path -LiteralPath $ProfilePath)) {
            New-Item -ItemType File -Path $ProfilePath -Force | Out-Null
            Write-Host "Datei erstellt: $ProfilePath" -ForegroundColor DarkGray
        }

        $content = Get-Content -LiteralPath $ProfilePath -Raw -ErrorAction SilentlyContinue
        if ($content -notmatch 'oh-my-posh init pwsh') {
            Write-Host "Schreibe Block:" -ForegroundColor DarkCyan
            Write-Host $block -ForegroundColor DarkGray
            # .NET-Append: robuster als Add-Content (keine Provider-/Encoding-Ueberraschungen)
            [System.IO.File]::AppendAllText($ProfilePath, $block, [System.Text.UTF8Encoding]::new($false))
        } else {
            Write-Host 'Zeile bereits vorhanden - kein Schreibvorgang.' -ForegroundColor Yellow
        }

        # Zurueck-lesen und KOMPLETTEN Inhalt loggen
        $verify = Get-Content -LiteralPath $ProfilePath -Raw -ErrorAction SilentlyContinue
        Write-Host "Inhalt nach Schreiben (Length=$($verify.Length)):" -ForegroundColor DarkCyan
        Write-Host "----------"; Write-Host $verify; Write-Host "----------"
        if ($verify -match 'oh-my-posh init pwsh') {
            Write-Host "OK  -> $ProfilePath" -ForegroundColor Green
        } else {
            Write-Warning "Zeile NICHT vorhanden nach Schreibversuch: $ProfilePath"
        }
    } catch {
        Write-Warning "Fehler bei '$ProfilePath': $($_.Exception.Message)"
    }
}

# Alle moeglichen Profilpfade sammeln, damit das tatsaechlich geladene Profil
# garantiert getroffen wird - unabhaengig von Edition (5.1 / 7) und davon, ob
# "Dokumente" lokal oder ueber OneDrive umgeleitet sind.
$candidates = New-Object System.Collections.Generic.List[string]

# 1) Echtes $PROFILE der laufenden Edition (autoritativ) + daraus die andere Edition
$candidates.Add($PROFILE)
$candidates.Add(($PROFILE -replace '\\WindowsPowerShell\\', '\PowerShell\'))
$candidates.Add(($PROFILE -replace '\\PowerShell\\',        '\WindowsPowerShell\'))

# 2) Dokumente-Ordner (lokal und OneDrive) explizit ergaenzen.
#    Basis-Verzeichnisse null-sicher sammeln (leere Env-Variablen ueberspringen).
$docBases = @(
    [Environment]::GetFolderPath('MyDocuments'),
    $HOME,
    $env:OneDrive,
    $env:OneDriveCommercial
) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }

$docRoots = foreach ($base in $docBases) {
    if (Split-Path -Leaf $base -ErrorAction SilentlyContinue) {
        if ((Split-Path -Leaf $base) -ieq 'Documents') { $base } else { Join-Path $base 'Documents' }
    }
}

foreach ($root in ($docRoots | Where-Object { $_ } | Select-Object -Unique)) {
    $candidates.Add((Join-Path $root 'PowerShell\Microsoft.PowerShell_profile.ps1'))        # PowerShell 7
    $candidates.Add((Join-Path $root 'WindowsPowerShell\Microsoft.PowerShell_profile.ps1')) # Windows PowerShell 5.1
}

# Duplikate entfernen und in jedes Profil schreiben
$candidates | Where-Object { $_ } | Select-Object -Unique | ForEach-Object { Set-OmpProfile -ProfilePath $_ }

# --- 4. Fira Code Nerd Font in Windows Terminal setzen --------------------
Write-Step 'Setze Schriftart in Windows Terminal...'
$wtSettings = Join-Path $env:LOCALAPPDATA `
    'Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json'

if (Test-Path $wtSettings) {
    try {
        $json = Get-Content $wtSettings -Raw | ConvertFrom-Json
        if (-not $json.profiles.defaults) {
            $json.profiles | Add-Member -NotePropertyName defaults -NotePropertyValue ([pscustomobject]@{}) -Force
        }
        $font = [pscustomobject]@{ face = 'FiraCode Nerd Font'; size = 10 }
        $json.profiles.defaults | Add-Member -NotePropertyName font -NotePropertyValue $font -Force
        ($json | ConvertTo-Json -Depth 32) | Set-Content $wtSettings -Encoding UTF8
        Write-Host "Schriftart 'FiraCode Nerd Font' (Groesse 10) als Standard gesetzt." -ForegroundColor Green
    } catch {
        Write-Warning "Konnte settings.json nicht automatisch anpassen: $($_.Exception.Message)"
        Write-Warning "Bitte Schriftart manuell auf 'FiraCode Nerd Font' setzen."
    }
} else {
    Write-Warning 'Windows Terminal settings.json nicht gefunden. Schriftart manuell setzen.'
}

# --- 5. Node.js via winget ------------------------------------------------
# Wird fuer den Marktstand benoetigt (HTML/CSS/JS-Loesungen, npm-Scripts).
Write-Step 'Installiere Node.js (OpenJS)...'
winget install -e --id OpenJS.NodeJS --source winget `
    --accept-package-agreements --accept-source-agreements --silent

# --- 5a. Bun (schneller JS-Runtime / Paket-Manager) ----------------------
Write-Step 'Installiere Bun (Oven-sh.Bun)...'
winget install -e --id Oven-sh.Bun --source winget `
    --accept-package-agreements --accept-source-agreements --silent

# --- 5b. uv (schneller Python-Paket-Manager / Runner) --------------------
Write-Step 'Installiere uv (astral-sh.uv)...'
winget install -e --id astral-sh.uv --source winget `
    --accept-package-agreements --accept-source-agreements --silent

# --- 6. Claude Code via winget --------------------------------------------
Write-Step 'Installiere Claude Code...'
winget install --id Anthropic.ClaudeCode --source winget `
    --accept-package-agreements --accept-source-agreements --silent

# Sicherstellen, dass die installierte Version up-to-date ist.
Write-Step 'Aktualisiere Claude Code (falls vorhanden)...'
winget upgrade --id Anthropic.ClaudeCode --source winget `
    --accept-package-agreements --accept-source-agreements --silent
if ($LASTEXITCODE -eq -1978335189) {
    # APPINSTALLER_CLI_ERROR_NO_APPLICABLE_UPDATE_FOUND - bereits aktuell, ok.
    Write-Host 'Claude Code ist bereits auf dem neuesten Stand.' -ForegroundColor Green
}

# --- 7. Quell-Ordner anlegen und Repo klonen ------------------------------
Write-Step 'Lege ~/src und ~/src/Code an und klone OpenDoor...'
$srcDir  = Join-Path $HOME 'src'
$codeDir = Join-Path $srcDir 'Code'
foreach ($d in @($srcDir, $codeDir)) {
    if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
}

# git sicherstellen (winget aktualisiert PATH erst in neuer Session)
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host 'git nicht gefunden - installiere via winget...' -ForegroundColor Yellow
    winget install --id Git.Git --source winget `
        --accept-package-agreements --accept-source-agreements --silent
    $gitBin = 'C:\Program Files\Git\cmd'
    if (Test-Path $gitBin) { $env:Path = "$gitBin;$env:Path" }
}

if (Get-Command git -ErrorAction SilentlyContinue) {
    $repoTarget = Join-Path $srcDir 'OpenDoor'
    if (Test-Path (Join-Path $repoTarget '.git')) {
        Write-Host "Repo bereits vorhanden - pulle neueste Version: $repoTarget" -ForegroundColor Yellow
        try {
            git -C $repoTarget pull --ff-only
            if ($LASTEXITCODE -eq 0) {
                Write-Host "Repo aktualisiert: $repoTarget" -ForegroundColor Green
            } else {
                Write-Warning "git pull --ff-only fehlgeschlagen (Exit $LASTEXITCODE). Lokale Aenderungen pruefen."
            }
        } catch {
            Write-Warning "git pull fehlgeschlagen: $($_.Exception.Message)"
        }
    } elseif (Test-Path $repoTarget) {
        Write-Warning "'$repoTarget' existiert, ist aber kein Git-Repo. Bitte Ordner pruefen / loeschen und Setup erneut ausfuehren."
    } else {
        git -C $srcDir clone https://github.com/florianbaer/OpenDoor
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Repo geklont nach: $repoTarget" -ForegroundColor Green
        } else {
            Write-Warning "git clone fehlgeschlagen (Exit $LASTEXITCODE)."
        }
    }
} else {
    Write-Warning 'git in dieser Session nicht verfuegbar. Bitte Shell neu starten und klonen:'
    Write-Warning "  git -C `"$srcDir`" clone https://github.com/florianbaer/OpenDoor"
}

# --- Fertig ----------------------------------------------------------------
Write-Host "`nFertig! Bitte Windows Terminal komplett neu starten," -ForegroundColor Green
Write-Host "damit Profile, Schriftart und PATH-Aenderungen wirksam werden." -ForegroundColor Green
Write-Host "Aktuelle Session testen mit:  . `$PROFILE" -ForegroundColor Green

# Init-Zeile zum Kopieren ausgeben und Profil in Notepad oeffnen
Write-Host "`nFalls die Zeile fehlt, manuell ins Profil einfuegen:" -ForegroundColor Cyan
Write-Host 'oh-my-posh init pwsh | Invoke-Expression'
notepad $PROFILE

# --- 8. Wechsle nach $codeDir und starte Claude Code ----------------------
# Setup-OhMyPosh hat Claude Code soeben installiert; der PATH ist in DIESER
# Session evtl. noch nicht aktualisiert. Daher: erst nach Code/ wechseln,
# dann claude.exe direkt oder ueber den winget-Link-Ordner starten.
Write-Step "Wechsle nach '$codeDir' und starte Claude Code..."
Set-Location -LiteralPath $codeDir

$claudeCmd = Get-Command -Name 'claude' -ErrorAction SilentlyContinue
if ($null -ne $claudeCmd) {
    $claudeExe = $claudeCmd.Source
} else {
    # winget legt Shims hier ab
    $candidates = @(
        Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Links\claude.exe'
        Join-Path $env:LOCALAPPDATA 'Programs\claude\claude.exe'
        Join-Path $env:LOCALAPPDATA 'Anthropic\ClaudeCode\claude.exe'
    )
    $claudeExe = $candidates | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1
}

if ($claudeExe) {
    Write-Host "Starte Claude Code in '$codeDir' ..." -ForegroundColor Cyan
    & $claudeExe
} else {
    Write-Warning "Claude Code (claude.exe) nicht gefunden. Bitte Terminal neu starten und im Ordner '$codeDir' 'claude' ausfuehren."
}
