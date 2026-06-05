# Advent of Code – Kalorienzähler

*Marktstand · Agentic Engineering · Übung 4 von 5*

**~ 10 Min · super einfach · Du brauchst: Summen rechnen**

Ein Trupp Wichtel wandert durch den Wald, jeder mit einem Rucksack voller Snacks. Frage: Wer hat am meisten Kalorien dabei? Klein, klar, und am Schluss gibt’s ein hübsches Balkendiagramm.

> **Dein Prompt**
>
> Jeder Wichtel trägt Snacks, eine Kalorienzahl pro Zeile. Zwischen den Wichteln steht eine Leerzeile. Frage: Welche Gesamt-Kalorienzahl hat der Wichtel mit am meisten dabei?

Eingabe:

  1000
  2000
  3000

  4000

  5000
  6000

  7000
  8000
  9000

  10000

Antwort muss 24000 sein. Lös das in Python: speicher den Code als Datei, führ ihn aus, zeig mir das Ergebnis und die Summe pro Wichtel. Erklär mir die Lösung Schritt für Schritt – ich bin Anfänger:in.

*Kurzform: schreib Claude einfach „bitte mache Aufgabe 4". Dann mit „löse Schritt 1 ... 6 von Aufgabe 4" durch die Schritte hier unten gehen.*

## So gehst du vor

**Schritt 1 – Aufgabe lesen**

Im Prompt stehen mehrere Wichtel, ihre Snacks pro Zeile, getrennt durch Leerzeilen. Zähl mit den Augen: welcher Wichtel hat am meisten? (Antwort: 24’000)

**Schritt 2 – Lass Claude die Lösung schreiben**

„Lös das in Python und zeig mir auch, wie viele Kalorien jeder einzelne Wichtel insgesamt dabei hat.“

**Schritt 3 – Lass dir die Lösung erklären**

„Erklär mir, wie du den Input in Gruppen aufgeteilt hast. Was ist eleganter: `split('\n\n')` oder eine Schleife mit Akkumulator?“

**Schritt 4 – Plot die Wichtel-Bilanz**

„Zeichne ein Balkendiagramm: jeder Wichtel ein Balken, Höhe = Kalorien-Summe. Markier den Top-Wichtel in einer anderen Farbe. Speicher als `wichtel.png` und öffne das Bild.“

**Schritt 5 – Lass Unit Tests schreiben**

„Schreib pytest-Tests: Beispiel-Eingabe gibt 24’000; leere Eingabe gibt 0; ein einziger Wichtel mit einer Zahl gibt diese Zahl. Führ die Tests aus.“

**Schritt 6 – README dazu schreiben**

„Erzeug ein README.md mit der Aufgabe in deinen Worten, wie man’s startet und wie man die Tests laufen lässt. Höchstens eine halbe Seite.“

## Wenn du noch Zeit hast

- „Wie hoch ist die Kalorien-Summe der TOP-3-Wichtel?“
- „Sortier alle Wichtel absteigend nach Kalorien und gib sie als Tabelle aus.“
- „Mach eine Variante: was, wenn jeder Wichtel maximal 10’000 Kalorien tragen darf? Wer überschreitet das?“

---

*Tipp: `"text".split('\n\n')` ist dein Freund, wenn Leerzeilen Gruppen trennen.*
