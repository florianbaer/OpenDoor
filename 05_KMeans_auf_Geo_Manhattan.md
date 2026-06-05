# K-Means auf Geo-Daten – Euklid vs. Manhattan

*Marktstand · Claude Code · Übung 5 von 5*

**~ 15 Min · CSV-Datei liegt bei · Du brauchst: Spass an Karten**

Wenn wir Standorte clustern, ist „Luftlinie“ nicht immer ehrlich. Hier ist die Datei swiss_cities.csv mit 15 Schweizer Städten samt Koordinaten. Du musst nichts abtippen – Claude liest die Datei direkt.

> **Dein Prompt**
>
> Lies die Datei swiss_cities.csv im aktuellen Ordner (Spalten: city, lat, lon). Implementier K-Means in Python (ohne scikit-learn) mit euklidischer Distanz und k=3. Speicher den Code, führ ihn aus und zeig mir: welche Stadt landet in welchem Cluster und wo sind die Centroids? Mach auch einen einfachen Scatter-Plot der Städte mit Cluster-Farben.

## So gehst du vor

**Schritt 1 – CSV lesen und mit Euklid clustern**

Im Prompt steht der Befehl. Claude liest swiss_cities.csv, baut K-Means mit euklidischer Distanz und clustert die Städte in 3 Regionen. Plot der Karte gibt’s dazu.

**Schritt 2 – Was ist Manhattan-Distanz?**

„Erklär mir Manhattan-Distanz mit einer Stadt-Analogie – warum heisst sie so? Und warum ist sie auf einem Strassen-Netz ehrlicher als Euklid?“

**Schritt 3 – Welche Distanz für welche Geo-Frage?**

„Welche anderen Distanzen passen für Geo-Daten? Haversine (Erdkrümmung)? Chebyshev? Sag mir kurz, wann jede einzelne besser ist als Euklid.“

**Schritt 4 – Distanz austauschen und Karte vergleichen**

„Wähl die Distanz, die für ‚wie weit muss man wirklich fahren‘ am besten passt – und erklär warum. Tausch sie in meinem Code aus und zeig mir die neue Karte. Welche Städte landen jetzt in einem anderen Cluster?“

**Schritt 5 – Lass Unit Tests schreiben**

„Schreib pytest-Tests mit bekannten Werten – z.B. Zürich–Bern ca. 95 km Luftlinie. Plus ein Test, der prüft, dass nach dem Wechsel auf eine andere Distanz mindestens eine Stadt das Cluster wechselt. Führ die Tests aus.“

**Schritt 6 – README dazu schreiben**

„Erzeug ein README.md: was das Skript macht, welche Distanzen es kennt und für welche Frage welche passt, wie man’s startet und wie man eine neue Stadt zur CSV hinzufügt. Mit dem Plot als Beispiel-Output eingebettet.“

## Wenn du noch Zeit hast

- „Nutz Haversine-Distanz – die berücksichtigt die Erdkrümmung. Wie ändern sich die Distanzen in km?“
- „Cluster die Städte nach Bevölkerungszahl statt Position – welche Distanz macht jetzt Sinn?“
- „Mach das Ganze interaktiv: Slider für k, Auswahl der Distanz, Live-Plot auf einer Karte.“

---

*Tipp: Die swiss_cities.csv liegt im selben Ordner wie dieses Handout.*
