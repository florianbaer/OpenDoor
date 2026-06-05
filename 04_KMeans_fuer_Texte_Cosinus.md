# K-Means für Texte – warum Cosinus oft besser ist

*Marktstand · Agentic Engineering · Übung 4 von 5*

**~ 15 Min · NLP-Geschmacksprobe · Du brauchst: 3 Mini-Vektoren**

Stell dir vor, du zählst, wie oft die Wörter „Krankheit“ und „Sport“ in drei Texten vorkommen. Jeder Text wird ein Punkt im 2D-Raum. Bei dieser Mini-Übung siehst du, warum euklidische Distanz auf Texten oft täuscht – und Cosinus die ehrliche Antwort gibt.

> **Dein Prompt**
>
> Drei „Texte“ als Wort-Häufigkeits-Vektoren (Krankheit, Sport):

  T1 = (2, 1)   — wenig Worte, doppelt so oft Krankheit wie Sport
  T2 = (20, 10) — viele Worte, gleiches Verhältnis wie T1
  T3 = (0, 1)   — wenig Worte, nur Sport

Implementier K-Means in Python (ohne scikit-learn) mit euklidischer Distanz und k=2. Welche zwei Texte landen zusammen? Speicher den Code, führ ihn aus und zeig mir die Cluster. Erklär dann in einem Satz, warum genau diese Aufteilung entsteht.

## So gehst du vor

**Schritt 1 – Cluster die 3 Texte mit Euklid**

Die drei Vektoren stehen im Prompt. Claude schreibt K-Means mit euklidischer Distanz, k=2. Welche zwei Texte landen zusammen? Wahrscheinlich {T1, T3} und {T2}.

**Schritt 2 – Was läuft hier schief?**

„T1 und T2 reden beide doppelt so viel über Krankheit wie über Sport – also über dasselbe Thema. T3 redet nur über Sport. Warum trennt Euklid die ‚falschen‘ Texte?“

**Schritt 3 – Was ist Cosinus-Ähnlichkeit?**

„Erklär mir Cosinus-Ähnlichkeit mit einer Alltags-Analogie und rechne sie für meine 3 Vektoren von Hand vor. Warum ist Cosinus für Texte fast immer die bessere Wahl?“

**Schritt 4 – Cosinus + Vektor-Plot**

„Wechsle in meinem K-Means die Distanz zu Cosinus. Plus: Plot die 3 Vektoren als Pfeile vom Ursprung (T1 + T2 zeigen in dieselbe Richtung, T3 woanders). Speicher als `vectors.png` und öffne das Bild. Jetzt sieht man sofort, warum Cosinus T1+T2 zusammen clustert.“

**Schritt 5 – Lass Unit Tests schreiben**

„Schreib pytest-Tests: Cosinus von zwei identischen Vektoren = 1; von senkrechten = 0; und für meine 3 Vektoren müssen mit Cosinus T1 und T2 in einem Cluster landen. Führ die Tests aus.“

**Schritt 6 – README dazu schreiben**

„Erzeug ein README.md mit: die 3 Mini-Texte, was sie bedeuten, warum Euklid hier täuscht, warum Cosinus die ehrliche Antwort gibt, wie man’s startet. Mit Beispiel-Output für beide Distanzen.“

## Wenn du noch Zeit hast

- „Füg einen vierten Text T4 = (1, 10) hinzu – wie ändert sich das Clustering mit Euklid vs. Cosinus?“
- „Visualisier die 3 Vektoren als Pfeile vom Ursprung und zeig, warum T1 und T2 in die gleiche Richtung zeigen.“
- „Bei welchen anderen Datentypen ausser Text wäre Cosinus eine gute Wahl?“

---

*Tipp: Wenn ein Algorithmus „nicht funktioniert“, liegt’s oft nicht am Algorithmus – sondern an der Metrik.*
