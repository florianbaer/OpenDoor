# Agentic Engineering Marktstand — Stand-Anleitung

Kurzanleitung für die Person, die den Marktstand „Agentic Engineering (Hands-on)"
am Helsana IT Event betreut.

## Was die Besucher:innen am Stand tun

Sie wählen eine der **5 Übungen** (Handouts auf dem Tisch) und arbeiten
sie direkt mit agentic engineering im Terminal durch (Claude Code als CLI).

| # | Übung | Worum es geht |
|---|---|---|
| 1 | AoC – Erste Aufgabe | Mini-Puzzle in einer Sprache deiner Wahl |
| 2 | AoC – Schwere Aufgabe | Strategie zuerst, dann Code |
| 3 | K-Means mit Euklid | 3 Punkte, K-Means von Hand bauen |
| 4 | K-Means für Texte (Cosinus) | Warum Cosinus auf Texten besser ist |
| 5 | K-Means auf Geo-Daten | CSV der Schweizer Städte, Euklid vs. Manhattan |

Daten- und Briefing-Dateien liegen im `Code/`-Ordner, damit Claude sie
direkt liest. `AGENT.md` instruiert den Agenten (Beginner-Niveau,
nur Python + Node verfügbar, Code speichern + ausführen).

## Zwischen zwei Besucher:innen

```powershell
.\reset.ps1
```

Das Script:

1. Löscht `Code/` (was die vorige Person geschrieben hat).
2. Erstellt `Code/` neu.
3. Kopiert alle `*.md`-Handouts und `*.csv`-Daten + `AGENT.md` rein.
4. Wechselt nach `Code/` und startet die Claude-CLI.

Läuft ohne Rückfrage durch.

## Initialer Setup (einmal pro Rechner)

```powershell
.\Setup-OhMyPosh.ps1
```

Installiert Oh My Posh, Fira Code Nerd Font, Node.js, Claude Code und
git via winget, richtet die PowerShell-Profile ein und klont das Repo
nach `~/src/OpenDoor`. Erzeugt zusätzlich `~/src/Code` als Arbeitsordner.

## Wenn jemand am Stand sitzt und nicht weiss, was wählen

- Erste Übung am Stand? → **01 AoC Erste Aufgabe**
- Schon mal mit AoC gearbeitet? → **02 AoC Schwere Aufgabe**
- Data-Science-Interesse? → **03**, dann **04** oder **05**
- Wenig Zeit? → **03** ist am schnellsten durchgespielt

## Typische Stolpersteine

- **Andere Sprache als Python/Node gewünscht** — `AGENT.md` erklärt das.
  Claude bietet automatisch die zwei Optionen an (Code zeigen ohne
  Ausführen / in Python umsetzen).
- **Claude CLI startet nicht** — `claude --version` checken. Wenn nicht
  installiert, neu installieren oder Person an einen Nachbarstand
  schicken.
- **Person hängt bei einem Schritt** — Claude direkt fragen lassen:
  „Erklär mir das nochmal einfacher" — funktioniert fast immer.
- **Tests schlagen fehl** — meistens fehlt eine pip-Library. Claude
  vorschlagen lassen: „installier die fehlende Dependency und versuch
  es nochmal."

## Dateien hier

- `01_AoC_Erste_Aufgabe.{docx,md}` — Handout für Besucher
- `02_AoC_Schwere_Aufgabe.{docx,md}`
- `03_KMeans_mit_Euklid.{docx,md}`
- `04_KMeans_fuer_Texte_Cosinus.{docx,md}`
- `05_KMeans_auf_Geo_Manhattan.{docx,md}`
- `swiss_cities.csv` — Datenfile für Übung 5
- `AGENT.md` — Briefing für die Claude-CLI (wird nach `Code/` kopiert)
- `reset.ps1` — Reset zwischen Besuchern
- `Setup-OhMyPosh.ps1` — Einmaliges Setup des Marktstand-Rechners
