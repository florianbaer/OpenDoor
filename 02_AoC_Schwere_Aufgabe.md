# Advent of Code – das knifflige Mini-Puzzle

*Marktstand · Claude Code · Übung 2 von 5*

**~ 15 Min · ein bisschen kniffliger · Du brauchst: Geduld**

Diese Aufgabe ist nicht schwer im Sinne von „viel Code“ – sondern darin, einen klugen Weg zu finden. Bei harten Aufgaben lohnt sich: erst Strategie klären, dann Code schreiben. Genau das üben wir hier.

> **Dein Prompt**
>
> Aufgabe: Ein Roboter startet bei (0, 0). Er bekommt eine Folge von Bewegungen – U (hoch), D (runter), L (links), R (rechts). Jeder Buchstabe heisst: einen Schritt in diese Richtung. Frage: Was ist die maximale Manhattan-Distanz, die der Roboter irgendwann während seines Pfades vom Ursprung erreicht?

Beispiel-Eingabe: UURRDDL
Erwartetes Ergebnis: 4 (er ist irgendwann bei (2, 2), das ist Manhattan-Distanz 4).

Wichtig: Schreib noch keinen Code. Erklär mir zuerst in 4-5 Bullet Points, wie du das Problem lösen würdest. Erst wenn ich „ok“ sage, schreibst du den Code.

## So gehst du vor

**Schritt 1 – Aufgabe verstehen**

Die Aufgabe steht im Prompt. Lies sie und überleg, wie du’s mit Papier und Bleistift lösen würdest – bevor Code ins Spiel kommt.

**Schritt 2 – Strategie zuerst, kein Code**

Sag Claude: „Schreib noch keinen Code. Erklär mir zuerst in 4-5 Bullet Points, wie du die Aufgabe angehst.“ Das verhindert wilde Lösungen und macht das Denken sichtbar.

**Schritt 3 – Code schreiben und testen**

Wenn die Strategie überzeugt: „Setz das jetzt in Python um. Speicher die Datei, führ sie mit der Beispiel-Eingabe aus und zeig mir das Ergebnis.“ Stimmt’s mit der erwarteten Antwort 4?

**Schritt 4 – Weiter denken**

„Würde dein Code auch funktionieren, wenn der Pfad 1000 Zeichen lang ist? Wo wäre der Engpass? Wie würdest du ihn schneller machen?“

**Schritt 5 – Lass Unit Tests schreiben**

„Schreib pytest-Tests: die Beispiel-Eingabe muss 4 ergeben; ein leerer Pfad gibt 0; nur U-Bewegungen geben die Anzahl U. Führ die Tests aus.“

**Schritt 6 – README dazu schreiben**

„Erzeug ein README.md mit der Aufgabe in deinen Worten, der Strategie aus Schritt 2, wie man Code und Tests startet und einer kurzen Komplexitäts-Analyse (O(n)? O(n²)?).“

## Wenn du noch Zeit hast

- „Mach eine Variante: nicht max Manhattan, sondern max euklidische Distanz. Was ändert sich?“
- „Visualisier den Pfad als kleine ASCII-Grafik im Terminal.“
- „Wie würde sich der Code ändern, wenn der Roboter Diagonalbewegungen darf?“

---

*Tipp: „Strategie zuerst, Code danach“ ist auch im Job ein guter Reflex.*
