# K-Means selbst bauen – mit nur 3 Punkten

*Marktstand · Agentic Engineering · Übung 3 von 5*

**~ 15 Min · Mini-Daten zum Anfassen · Du brauchst: Python im Kopf**

Wir bauen K-Means von Hand – mit drei winzigen Datenpunkten, die du auf einer Serviette nachrechnen kannst. Genau so versteht man, was unter der Haube passiert.

> **Dein Prompt**
>
> Implementier mir K-Means in Python von Grund auf (ohne scikit-learn), mit euklidischer Distanz und k=2. Die Datenpunkte:

  P1 = (1, 1)
  P2 = (2, 1)
  P3 = (8, 8)

Speicher den Code als Datei, führ ihn aus und zeig mir: welcher Punkt landet in welchem Cluster und wo sind die Centroids? Erklär mir danach in einem Satz, warum genau diese Cluster entstanden sind.

## So gehst du vor

**Schritt 1 – Bau K-Means in Python mit Euklid**

Die drei Punkte stehen im Prompt. Claude schreibt K-Means von Hand (ohne scikit-learn), speichert die Datei, führt sie aus und zeigt dir: welcher Punkt landet in welchem Cluster?

**Schritt 2 – Was ist euklidische Distanz?**

„Erklär mir die euklidische Distanz so, dass ich sie meinem nicht-technischen Kollegen erklären könnte. Rechne sie für die drei Punkte einmal von Hand vor.“

**Schritt 3 – Welche Distanzen gibt es sonst?**

„Welche anderen Distanzen kennst du? Erklär mir 3 davon kurz und sag jeweils, in welcher Situation sie besser als Euklid sein könnte.“

**Schritt 4 – Eine andere Distanz ausprobieren**

„Wähle eine andere Distanz, die für diese Punkte vielleicht etwas anders berechnet wird. Erklär warum – und dann tausch sie in meinem K-Means aus. Vergleich die Distanz-Zahlen vorher/nachher.“

**Schritt 5 – Lass Unit Tests schreiben**

„Schreib pytest-Tests für die Distanzfunktion mit den drei Punkten als Ground Truth – ich kann sie ja von Hand nachrechnen. Plus ein Test, dass K-Means die erwarteten Cluster liefert. Führ die Tests aus.“

**Schritt 6 – README dazu schreiben**

„Erzeug ein README.md, das den Mini-Datensatz, den Algorithmus und die Distanz erklärt. Wie startet man’s, wie tauscht man die Distanz aus? Mit erwarteter Ausgabe als Beispiel.“

## Wenn du noch Zeit hast

- „Mach die Distanzfunktion austauschbar (Strategy Pattern). Vergleich Euklid vs. Manhattan auf denselben Punkten.“
- „Füg einen vierten Punkt hinzu und schau, ob sich die Cluster verändern.“
- „Mach einen kleinen Plot der drei Punkte mit Cluster-Farben und Centroid-Markern.“

---

*Tipp: „Erst bauen, dann erklären lassen“ – so versteht man Code, statt ihn nur zu sammeln.*
