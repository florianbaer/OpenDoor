# AGENT.md — Briefing für den Coding-Assistenten

Du arbeitest im Code-Ordner eines Besuchers am **Helsana IT Event**,
Marktstand „Claude Code (Hands-on)". Die Person probiert Claude Code
womöglich zum ersten Mal aus.

## Was in diesem Ordner liegt

- **Übungen als Markdown-Dateien:** `01_AoC_Erste_Aufgabe.md` …
  `05_KMeans_auf_Geo_Manhattan.md`. Jede Datei enthält die Aufgabe, einen
  fertigen Prompt im Abschnitt **„Dein Prompt"** und Schritte 1–6. Die
  Person hat sich für eine Übung entschieden und arbeitet diese gerade
  durch.
- **Datenfiles für die Übungen:** liegen direkt in diesem Ordner
  (z. B. `swiss_cities.csv` mit Spalten `city, lat, lon` für die Geo-
  Übung). Diese Daten **direkt einlesen** — nicht neu generieren.
- **Code-Dateien**, die du selbst anlegst, gehören ebenfalls in diesen
  Ordner. Schreib Tests in `tests/` oder als `test_*.py` daneben.

## So arbeitest du

- **Lies zuerst die relevante Übungs-MD-Datei**, bevor du loslegst. Dort
  steht, in welchem Schritt die Person steckt und was als Nächstes ansteht.
- **Code wird gespeichert UND ausgeführt** — nicht nur gezeigt. Die Person
  will das echte Ergebnis im Terminal sehen.
- **Erklär beginner-tauglich**, ohne überheblich zu sein. Fachbegriffe
  einmal kurz auflösen.
- **Halt dich an die Schrittfolge der Übung.** Wenn die Person Schritt 3
  bearbeitet, geh nicht eigenmächtig zu Schritt 5 weiter.
- **Bei Unklarheit lieber kurz nachfragen** als raten.

## Welche Sprachen laufen auf diesem Rechner

Auf diesem Marktstand-Rechner sind installiert: **Python**, **Node.js**,
und natürlich **HTML/CSS/JavaScript** (im Browser ausführbar). **Mehr
nicht.** Keine Rust-, Go-, Java-, C#-, Swift-, Kotlin-, Ruby-, Elixir-
oder sonstigen Toolchains.

Wenn die Person Code in einer anderen Sprache will:

1. Sag ihr ehrlich, dass auf dieser Maschine nur Python + Node verfügbar
   sind und dass der Code in der Wunschsprache zwar geschrieben, aber
   hier nicht ausgeführt werden kann.
2. Biete zwei Optionen an:
   - **(a)** Code in der Wunschsprache schreiben und als Datei
     speichern — gut zum Mitnehmen, zum Lesen, zum Vergleichen. Nicht
     ausgeführt.
   - **(b)** Code in Python oder Node ausführen, damit die Person das
     Ergebnis live sieht.
3. Lass die Person wählen. Mach nichts ungefragt.

Versuch nicht, fehlende Compiler/Runtimes nachzuinstallieren oder
unbekannte Binaries aufzurufen — das frisst Zeit und endet in
Fehlermeldungen.

## Sprache

Antworten in der Sprache, in der die Person fragt — Standard ist Deutsch.

## Wenn du Tests oder README schreibst (Schritte 5 + 6)

- Tests gehen mit `pytest` (Python) oder dem Standard-Test-Tool der
  jeweiligen Sprache. Speichern, ausführen, grünes Resultat zeigen.
- README ist eine knappe `README.md` im selben Ordner: Was, Wie starten,
  Wie testen — höchstens eine halbe Seite.
