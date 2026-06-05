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

*Kurzform: schreib Claude einfach „bitte mache Aufgabe 3". Dann mit „löse Schritt 1 ... 6 von Aufgabe 3" durch die Schritte hier unten gehen.*

## So gehst du vor

**Schritt 1 – K-Means verstehen (falls neu)**

Wenn dir „K-Means“ oder „Clustering“ nichts sagt, frag Claude zuerst: „Was ist K-Means Clustering und wie funktioniert es? Erklär mir’s mit einer Alltags-Analogie.“ Erst weitermachen, wenn’s klick gemacht hat.

**Schritt 2 – Bau K-Means in Python mit Euklid**

Die drei Punkte stehen im Prompt. Claude schreibt K-Means von Hand (ohne scikit-learn), speichert die Datei, führt sie aus und zeigt dir: welcher Punkt landet in welchem Cluster?

**Schritt 3 – Distanzen verstehen**

„Erklär mir die euklidische Distanz mit einer Alltags-Analogie und rechne sie für die drei Punkte von Hand vor. Danach: welche 3 anderen Distanzen gibt es, und wann ist welche besser als Euklid?“

**Schritt 4 – Vorher/Nachher-Plot mit anderer Distanz**

„Mach einen Plot mit 2 Panels: links Cluster mit Euklid, rechts Cluster mit Manhattan (oder einer anderen Distanz). Speicher als `kmeans_compare.png` und öffne das Bild. Welcher Punkt landet wo unterschiedlich – und warum?“

**Schritt 5 – Lass Unit Tests schreiben**

„Schreib pytest-Tests für die Distanzfunktion mit den drei Punkten als Ground Truth (ich kann sie von Hand nachrechnen). Plus ein Test, dass K-Means die erwarteten Cluster liefert – nutz dafür einen festen Seed (`random.seed(42)`), damit der Test reproduzierbar ist.“

**Schritt 6 – README dazu schreiben**

„Erzeug ein README.md, das den Mini-Datensatz, den Algorithmus und die Distanz erklärt. Wie startet man’s, wie tauscht man die Distanz aus? Mit erwarteter Ausgabe als Beispiel.“

## Wenn du noch Zeit hast

- „Mach die Distanzfunktion austauschbar (Strategy Pattern). Vergleich Euklid vs. Manhattan auf denselben Punkten.“
- „Füg einen vierten Punkt hinzu und schau, ob sich die Cluster verändern.“
- „Mach einen kleinen Plot der drei Punkte mit Cluster-Farben und Centroid-Markern.“

---

*Tipp: „Erst bauen, dann erklären lassen“ – so versteht man Code, statt ihn nur zu sammeln.*
