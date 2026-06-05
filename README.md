# Agentic Engineering Marktstand — Stand-Anleitung

Kurzanleitung für die Person, die den Marktstand „Agentic Engineering (Hands-on)"
am Helsana IT Event betreut.

## Was die Besucher:innen am Stand tun

Sie wählen eine der **5 Übungen** (Handouts auf dem Tisch) und arbeiten
sie direkt mit agentic engineering im Terminal durch (Claude Code als CLI).

| # | Übung | Worum es geht |
|---|---|---|
| 1 | AoC – Erste Aufgabe | Mini-Puzzle in einer Sprache deiner Wahl |
| 2 | AoC – Tiefenmesser | Anstiege in Sonar-Messungen zählen + Liniendiagramm |
| 3 | K-Means mit Euklid | 3 Punkte, K-Means von Hand bauen |
| 4 | AoC – Kalorienzähler | Wichtel-Snacks summieren, max finden + Balkendiagramm |
| 5 | K-Means auf Geo-Daten | CSV der Schweizer Städte, Euklid vs. Manhattan/Haversine |

Daten- und Briefing-Dateien liegen im `Code/`-Ordner, damit Claude sie
direkt liest. `AGENT.md` instruiert den Agenten (Beginner-Niveau,
nur Python + Node verfügbar, Code speichern + ausführen).

## Zwischen zwei Besucher:innen

Bei jedem Personenwechsel **in dieser Reihenfolge**:

1. **Neuen Tab im Terminal öffnen.** Zuerst öffnen, sonst geht das
   ganze Terminal zu.
2. **Alten Tab des vorherigen Gastes schliessen.**
3. Ins Repo wechseln:
   ```powershell
   cd src/OpenDoor
   ```
4. Reset-Script starten:
   ```powershell
   .\reset.ps1
   ```

Das Script:

1. Macht `git pull` auf OpenDoor (neueste Handouts / `CLAUDE.md` / `AGENTS.md`).
2. Stellt sicher, dass `~/src/Code` existiert (legt es an, falls nicht).
3. Kopiert alle `*.md`-Handouts (inkl. `CLAUDE.md` und `AGENTS.md`) plus
   `*.csv`-Daten nach `Code/` — überschreibt vorhandene, löscht nichts.
4. Wechselt nach `Code/` und startet die Claude-CLI mit einem
   Initial-Prompt, sodass die Welcome-Nachricht sofort kommt.

Läuft ohne Rückfrage durch.

## Initialer Setup (einmal pro Rechner)

```powershell
.\Setup-OhMyPosh.ps1
```

Installiert Oh My Posh, Fira Code Nerd Font, Node.js, Claude Code und
git via winget, richtet die PowerShell-Profile ein und klont das Repo
nach `~/src/OpenDoor`. Erzeugt zusätzlich `~/src/Code` als Arbeitsordner.

## Wenn jemand am Stand sitzt und nicht weiss, was wählen

- Erste Übung am Stand? → **01 AoC Erste Aufgabe** (Trebuchet) oder
  **02 Tiefenmesser** (noch einfacher)
- Lust auf einen weiteren Mini-Brainteaser? → **04 Kalorienzähler**
- Data-Science-Interesse? → **03 K-Means Euklid**, dann **05 Geo-K-Means**
- Wenig Zeit? → **02 Tiefenmesser** oder **04 Kalorienzähler** sind am
  schnellsten durchgespielt

## Typische Stolpersteine

- **Notebook 05 spinnt manchmal** — wenn es hängt, einfach neu starten.
  Das **Login-Passwort** bekommst du vom Organisator.
- **Internet weg** — Claude Code braucht eine Verbindung. Im WLAN
  **„Helsana-Guest"** mit dem eigenen persönlichen Account anmelden,
  dann kann sofort weitergearbeitet werden.
- **Andere Sprache als Python/Node gewünscht** — `AGENTS.md` / `CLAUDE.md`
  erklären das. Claude bietet automatisch die zwei Optionen an (Code
  zeigen ohne Ausführen / in Python umsetzen).
- **Claude CLI startet nicht** — `claude --version` checken. Wenn nicht
  installiert, neu installieren oder Person an einen Nachbarstand
  schicken.
- **Person hängt bei einem Schritt** — Claude direkt fragen lassen:
  „Erklär mir das nochmal einfacher" — funktioniert fast immer.
- **Tests schlagen fehl** — meistens fehlt eine pip-Library. Claude
  vorschlagen lassen: „installier die fehlende Dependency und versuch
  es nochmal."
- **Webserver hängt nach Demo** — Claude darf laut `CLAUDE.md` einen
  Server max. 2 Minuten laufen lassen und muss ihn danach selbst killen.
  Wenn doch mal einer hängt: PowerShell `Get-Process node, python |
  Stop-Process -Force`, dann `reset.ps1`.

## FAQ

> ⚠️ **WICHTIG — Beim Benutzerwechsel (in dieser Reihenfolge!):**
>
> 1. **Neuen Tab im Terminal öffnen.** Zuerst öffnen, sonst geht das
>    ganze Terminal zu.
> 2. **Alten Tab des vorherigen Gastes schliessen.**
> 3. `cd src/OpenDoor/`
> 4. `.\reset.ps1`
>
> **Das ist mega wichtig.** Sonst arbeitet die nächste Person in der
> Session der vorigen weiter oder Reset hängt.

**„Kann ich auch Opus 4.8 probieren?"** — Ja, wenn jemand unbedingt
will, dann gerne. Für die kleinen Übungen hier ist es allerdings
overkill: Sonnet reicht für alles, was am Marktstand vorkommt, und ist
schneller. Opus also nur bewusst einsetzen, nicht als Default.

**„Darf ich Chrome / Internet aufmachen?"** — Nur, wenn eine Webseite
explizit angezeigt werden soll (z. B. um etwas konkret zu zeigen).
Sonstiges Surfen ist am Stand nicht nötig — alles, was es für die
Übungen braucht, liegt im Ordner oder kommt von Claude.

**„Muss ich alleine arbeiten?"** — Nein. Am PC sind normalerweise 5
Personen gleichzeitig — Gruppenarbeit ist ausdrücklich erwünscht.
Zusammen probieren, diskutieren, sich gegenseitig die Schritte erklären
macht meistens mehr Spass und führt zu besseren Aha-Momenten.

**„Wer hat das PC-Passwort?"** — **Markus**, **Lea**, **Stefan** und
**Florian**. Bei einem Neustart oder Login-Problem einfach eine dieser
Personen ansprechen.

**„Was, wenn `reset.ps1` nicht funktioniert?"** — Kein Stress, kein
Debugging am Stand: einfach **den PC neu starten**. Danach Terminal
öffnen → `cd src/OpenDoor` → `.\reset.ps1`. Funktioniert in 99 % der
Fälle sofort wieder.

## Dateien hier

- `01_AoC_Erste_Aufgabe.{docx,md}` — Handout für Besucher
- `02_AoC_Tiefenmesser.{docx,md}`
- `03_KMeans_mit_Euklid.{docx,md}`
- `04_AoC_Kalorienzaehler.{docx,md}`
- `05_KMeans_auf_Geo_Manhattan.{docx,md}`
- `swiss_cities.csv` — Datenfile für Übung 5
- `AGENT.md` — Briefing für die Claude-CLI (wird nach `Code/` kopiert)
- `reset.ps1` — Reset zwischen Besuchern
- `Setup-OhMyPosh.ps1` — Einmaliges Setup des Marktstand-Rechners
