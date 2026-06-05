# Advent of Code – Tiefenmesser

*Marktstand · Agentic Engineering · Übung 2 von 5*

**~ 10 Min · simpel und befriedigend · Du brauchst: Zählen können**

Ein U-Boot-Sonar misst jede Sekunde die Wassertiefe. Frage: Wie oft ist die Tiefe gegenüber dem vorherigen Messwert grösser geworden? Simple Logik, klares Resultat, schöner Plot zum Schluss.

> **Dein Prompt**
>
> Ein U-Boot-Sonar misst jede Sekunde die Wassertiefe. Hier sind 10 Messungen:

  199, 200, 208, 210, 200, 207, 240, 269, 260, 263

Frage: Wie oft ist die Tiefe gegenüber der vorhergehenden Messung GRÖSSER geworden? (Antwort: 7)

Lös das in Python: speicher den Code als Datei, führ ihn aus, zeig mir das Ergebnis. Erklär mir die Lösung Schritt für Schritt – ich bin Anfänger:in.

*Kurzform: schreib Claude einfach „bitte mache Aufgabe 2". Dann mit „löse Schritt 1 ... 6 von Aufgabe 2" durch die Schritte hier unten gehen.*

## So gehst du vor

**Schritt 1 – Aufgabe lesen**

Im Prompt stehen 10 Tiefenmessungen. Such mit den Augen die Stellen, wo der Wert höher ist als der davor. Du solltest 7 Stellen finden.

**Schritt 2 – Lass Claude die Lösung schreiben**

Wähl eine Sprache (Python ist am einfachsten). Claude schreibt den Code, speichert ihn und führt ihn aus. Antwort muss 7 sein.

**Schritt 3 – Lass dir die Lösung erklären**

„Erklär mir deine Lösung in einfachen Worten.“ Spannend: was ist eleganter – eine for-Schleife oder ein One-Liner mit `zip()`?

**Schritt 4 – Plot die Tiefenkurve**

„Zeichne die Tiefenmessungen als Liniendiagramm. Markier mit roten Punkten alle Stellen, wo die Tiefe gegenüber der vorigen Messung gestiegen ist. Speicher als `depth.png` und öffne das Bild.“

**Schritt 5 – Lass Unit Tests schreiben**

„Schreib pytest-Tests: die Beispiel-Eingabe gibt 7; eine streng aufsteigende Folge mit N Zahlen gibt N−1; eine Folge mit allen gleichen Zahlen gibt 0. Führ die Tests aus.“

**Schritt 6 – README dazu schreiben**

„Erzeug ein README.md mit der Aufgabe in deinen Worten, wie man’s startet und wie man die Tests laufen lässt. Höchstens eine halbe Seite.“

## Wenn du noch Zeit hast

- „Erweiter: zähle wie oft die Tiefe in 3er-Fenstern gestiegen ist (Summen-Fenster).“
- „Was ist die längste Strecke ohne Pause, in der die Tiefe nur stieg?“
- „Bau das Ganze in eine andere Sprache nach – Rust, TypeScript, was du magst.“

---

*Tipp: Beim Vergleich „grösser als“ hilft `zip(liste, liste[1:])` enorm.*
