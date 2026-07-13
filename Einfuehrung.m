%[text] # OPTIMPROBLEM
%[text] Dieses Skript gibt eine Einführung in die Optimierung mit Matlab.
%[text] ## Initialisierung
% Beispiel mit maximize als Ziel:
prob01 = optimproblem("Description", "Wir schreiben was unser optimproblem machen soll", "ObjectiveSense", "max");

% Beispiel mit minimize als Ziel:
prob02 = optimproblem("Description", "Wir schreiben was unser optimproblem machen soll", "ObjectiveSense", "min");
%[text] Wie in den beiden obigen Beispielen gezeigt, beginnt die Initialisierung eines Optimierungsproblems mit der Zuweisung eines Names, zum Beispiel **`prob01`** oder **`prob02`**.  Die eigentliche Definition des Optimierungsproblem laesst sich in zwei Hauptkomponenten unterteilen: die **`"Description"`** und den **`"ObjectiveSense"`**. Der erste Teil dient nur dem Programmierer dazu, die konkrete Zielsetzung des jeweiligen Optimierungsproblems zu dokumentieren. Die zweite Komponente hingegen bildet den Kern des Optimierungsproblems, da sie dem Programm vorgibt, welche Eigenschaft bzw. Ausrichtung bei der Lösung des Problems einzuhalten ist. Da das Ziel dieses Projekts die Erstellung eines Modells zur Optimierung des Kraftwerkseinsatzes, insbesondere die Kostenoptimierung, ist, wird der ObjectiveSense, den wir verwenden, minimize **`(min)`** sein.
%%
%[text] ## Entscheidungsvariablen
%[text] Zur Erstellung einer Entscheidungsvariablen **`(optimvar)`** folgt man einem ähnlichen Vorgehen wie bei der Definition eines Optimierungsproblems **(****`optimproblem`****)**. In diesem Tutorium werden zwei Typen von optimvar vorgestellt, die im Verlauf des Projekts am häufigsten verwendet werden.
%[text] Zu Beginn wird, wie im Fall der optimproblem, die optimvar initialisiert: "**`Variablenname = optimvar();`**". Im Anschluss werden die Eigenschaften festgelegt, die die Variable charakterisieren. Wie bereits bei der Definition eines optimproblem lässt sich auch die Struktur einer optimvar in verschiedene Komponenten teilen. Der erste Schritt besteht darin, den Namen der optimvar explizit festzulegen. Der Einfachheit halber empfiehl es sich, denselben Namen wie bei der Initialisierung zu verwenden, zum Beispiel: **`z = optimvar(´z´)`**; Im zweiten Schritt wird die Dimension der Variablen definiert. In den nachfolgenden Beispielen entsteht im ersten Fall eine optimvar der Größe 3x3, im zweiten Fall eine der Größe 4x5. Werden keine Dimensionen deklariert, wird die optimvar standartmäßig mit der Größe 1x1x1 initialisiert.
%[text] Die dritte Eigenschaft betrifft den Typ der Variablen, also ob diese kontinuirlich oder ganzzahlig ist. Dies geschieht durch die Angabe **`(´Type´,´gewünschter_Typ´)`**. Dabei ist sorgfältig zu entscheiden, ob die Variable ausschließlich ganzzahlige Werte **`(Typ: "integer")`** annehmen darf oder auch kontinuierliche Werte **`(Typ: "continuous")`** zulässig sind. Abschließend werden die letzten beiden Parameter festgelegt: LowerBound und UpperBound. Diese definieren den minimalen bzw. maximalen Wert, den die optimvar annehmen kann.
% Beispiel 1
x = optimvar('x', 3, 3, 'Type', 'continuous', 'LowerBound', 0, 'UpperBound', 100);
%[text] Im ersten Beispel wird eine optimvar mit dem Name x, der Dimension 3x3 und einem kontinuierlichen Werteberich zwischen 0 und 100 initialisiert. Eine solche Initialisierung ist insbesondere dann hilfreich, wenn Variablen unterschiedliche Werte annehmen dürfen, jedoch ein Maximalwert nicht überschreiten sollen. **!!!Achtung!!!** Wenn LowerBound größer 0 ist, dann darf die Variable nicht mehr den Wert Null annehmen.
% Beispiel 2
y = optimvar('y', 4, 5, 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1);
%[text] Im zweiten Beispel wird eine optimvar mit dem Name y, der Dimension 4x5 und ganzzahligen Werten im Bereich von 0 bis 1 definiert. Diese Variable kann somit nur die Werte 0 oder 1 annehmen und wird funktional als boolesche Variable verwendet.
%%
%[text] ## Zielfunktion
prob03 = optimproblem('ObjectiveSense', 'max');
x = optimvar('x', 2, 1, 'LowerBound', 0, 'UpperBound', 100);

% Zielfunktion
prob03.Objective = x(1) + 2*x(2);
%[text] Jedes Optimierungsproblem hat zum Ziel, eine bestimmte Funktion auf optimale Weise zu lösen. Diese Funktion wird als Zielfunktion bezeichnet. Um die Zielfunktion zu deklarieren, muss dem besteheden Problem **".****`Objektive`****"** hinzugefügt werden.  Anschließend muss die mathematische Formel der Zielfunktion geschrieben werden, wie im Beispiel: **`"x(1) + 2*x(2);"`**. In diesem Fall ist die Zielfunktion des Optimproblem die Summe aus der Variablen **`x(1)`** und dem doppelten Quadrat von **`x(2)`** zu maximieren.
%%
%[text] ## Lineare Nebenbedingungen
%[text] Bislang haben wir gesehen, wie sich ein einfaches Optimierungsproblem formulieren lässt, das ausschließlich von den spezifischen Eigenschaften der Optimierungsvariablen und der Zielfunktion abhängt. Im weiteren Verlauf des Entwurfs- bzw. Plannungsprozesses müssen jedoch zusätzliche Einschränkungen und Bedingungen berücksichtigt werden, die mithilfe linearer Nebenbedingungen implementiert werden können.
%[text] Zur Erklärung greifen wir das zuvor behandelte Beispiel erneut auf und formulieren ein einfaches Optimierungsproblem, diesmal jedoch ohne die Angabe einer oberen Schranke **(****`UpperBound`****)** für die Variable "x". Das Ziel besteht weiterhin darin, die Summe von **`x(1)`** und **`2*x(2)`** zu maximieren.
prob04 = optimproblem('ObjectiveSense', 'max');
x = optimvar('x', 2, 1, 'LowerBound', 0);
prob04.Objective = x(1) + 2*x(2);
%[text] Nun sollen jedoch die Werte von **`x(1)`** und **`x(2)`** mithilfe geeigneter Nebenbedingungen eingeschränkt werden. Nachfolgend wird ein Beispiel für eine mögliche Implementierung gezeigt.
% Drei beispielhafte Nebenbedingungen
cons1 = x(1) + x(2) <= 40;
cons2 = x(1) + 5*x(2) <= 100;
cons3 = 2*x(1) + x(2)/2 <= 60;
prob04.Constraints.cons1 = cons1;
prob04.Constraints.cons2 = cons2;
prob04.Constraints.cons3 = cons3;
%[text] Wie ersichtlich, wurden drei verschiedene Gleichungen bzw. Ungleichungen definiert. Alle diese Restriktionen wirken direkt auf die Werte, die die Variable x, insbesondere **`x(1)`** und **`x(2)`**, annehmen kann. Die Aufgabe des Programms besteht darin, unter Berücksichtigung dieser Bedingungen die optimale Lösung zu finden, die alle Eigenschaften und Anforderungen des Problems erfüllt.
%[text] Um eine Nebenbedingung zu definieren, wird zunächst der jeweilige Bedingungsname festgelegt, anschließend die Eigenschaft, die erfüllt werden muss. Beispielsweise: **`cons1= x(1)+ x(2) <= 40`**. Daraufhin muss dem Programm mitgeteilt werden, dass es sich um eine Nebenbedingung des Optimierungsproblems handelt. Dies geschieht durch den Befehl: **`problem_name.Constraints.constraint_name = constraint_variable`**. (Zur Vereinfachung werden dabei in der Regel für **`constraint_name`** und **`constraint_variable`** dieselben Bezeichnungen verwendet.)
%%
%[text] ## Lösung
%[text] Um ein Optimierungsproblem zu lösen, wird in diesem Projekt eine Variante der solve-Method verwendet.
sol04 = prob04.solve("solver", "linprog"); %[output:8ccab912]
%[text] Der Name der Lösung kann frei gewählt werden, während der Problemname selbstverständlich dem zuvor definierten Namen entspricht. In dieser Variante der solve-Methode muss immer angegeben werden, welcher Solver verwendet werden soll. Dies erfolgt durch entsprechende Deklaration in der Befehlszeile. Verwenden Sie "**`intlinprog`**", wenn erweiterte Ganzzahligkeitsbedingungen vorliegen, oder "**`linprog`**", wenn keine Ganzzahligkeitsbedingungen bestehen.
%%
%[text] # Nützliche Funktionen
%[text] ## Repmat
A = diag([100 200 300]);
B = repmat(A,2,3);
%[text] **`B = repmat(A,r1,...,rN)`** gibt eine Liste von Skalaren an, r1,..,rN, die beschreibt, wie Kopien von A in jeder Dimension angeordnet sind. Wenn wir nur zwei Dimensionen haben, bezeichnet die erste die Zeile (im Beispiel 2) und die zweite die Spalten (im Beispiel 3).
%%
%[text] ## Num2str
s = num2str(pi);
%s = '3.1416'
%[text] Die Funktion **`num2str`** konvertiert ein numerisches Array in ein Zeichenarray, das die entsprechenden Zahlen darstellt. Das Ausgabeformat hängt von der Größenordnung der ursprünglichen Werte ab. **`num2str`** ist insbesondere nützlich, um Diagramme mit numerischen Werten zu beschriften und zu betiteln.
%[text] **!!!Hinweis!!!** In unserem Projekt arbeiten wir mit einer großen Anzahl von Variabeln und Nebenbedingungen, die für jedes Kraftwerk und für jeden Zeitschritt wiederholt definiert werden. In diesem Kontext erweist sich die Verwendung von **`num2str`** als besonders hilfreich, um jedem "Objekt" einen eindeutigen und aussagekräftigen Namen zuzuweisen. Dies trägt dazu bei, den Code besser lesbar zu machen und die Debugging-Phase erheblich zuvereinfachen, da die Identifikation möglicher Fehler während der Entwicklung erleichtert wird.
% Beispiel für constraints
for j = 1:npp
    for t= 1:nT
        probAP.Constraints.(['nameNebenbedingung_', num2str(j), num2str(t)]) = funktion;
    end
end
%%
%[text] # Grafische Darstellung
%[text] Sehr wichtig für die Durchführung des Projekts ist es, die erzielten Ergebnisse beobachten und korrekt analysieren zu können. Zu diesem Zweck ist es erforderlich, die grafischen Darstellungen ordnungsgemäß in das entwickelte Programm zu implementieren.
%[text] ## Figure
%[text] **`figure`** erstellt ein neues Abbildungsfenster mit Standardwerten für die Eigenschaften. Die resultierende Abbildung ist die aktuelle Abbildung.
figure;
%[text] Wenn man ein neues Bild erstellen möchte, muss die Funktion "**`figure`**" verwendet werden, da die Grafiken sonst im selben Fenster dargestellt werden. Wenn man zwei verschiedene Grafiken im selben Fenster/in derselben Abbildung überlagern möchte, benutzt man den Befehl:
hold on;
%%
%[text] ## Bar
y = [75 91 105 123.5 131 150 179 203 226 249 281.5];
bar(y);
%[text] Der Befehl **`bar(y)`** erstellt ein Balkendiagramm, bei dem jedem Element in y ein Balken zugeordnet wird.  Um eine einzelne Balkenreihe darzustellen, muss y als vector der Länge m angegeben werden. Die Balken werden dabei entlang der x-Achse von 1 bis m positioniert. Sollten die Balken hingegen an einer bestimmten Position ausgegeben werden, so muss diese explizit angegeben werden, beispielweise wie folgt:
x = 1900:10:2000;
y = [75 91 105 123.5 131 150 179 203 226 249 281.5];
bar(x, y);
%[text] #### Stacked Bars
%[text] In der Funktion **`bar()`** ist es, falls eine Gruppe von Balken für denselben x-Wert dargestellt werden soll, auch möglich, den gewünschten Darstellungsstil anzugeben **(z.B:** **`bar(y, style);`****)**. Für dieses Projekt ist es besonders sinnvoll, die sogenannte "stacked Bars"-Darstellung zu berücksichtigen.
y = [2 2 3; 2 5 6; 2 8 9; 2 11 12];
bar(y, 'stacked');
%[text] Bei Verwendung des Stils "**`stacked`**" wird für jede Zeile der Wertenmatrix y ein Balken dargestellt, dessen Höhe jedoch der Summe der Elemente de jeweiligen Zeile entspricht. Jedes Element, aus dem sich der einzelne Balken zusammensetzt, hat eine andere Farbe als die anderen Elemente. Auf diese Weise lassen sich die einzelnen Beiträge jedes Elements unterscheiden. Auch in diesem Fall kann, falls gewünscht, die Position auf der x-Achse, an der die Balken gezeichnet werden sollen, ausdrücklich angegeben werden, beispielweise wie folgt:
 x = 2020; 
 y = [30 50 23]; 
 b = bar(x, y, "stacked");
%%
%[text] ## Plot
%[text] **`plot(X, Y)`** erstellt ein 2D-Liniendiagramm der Daten in Y im Vergleich zu den entsprechenden Werten in X. Um eine Reihe von Koordinaten zu zeichnen, die durch Liniensegmente verbunden sind, müssen im Allgemeinen X und Y als Vektoren gleicher Länge angegeben werden.
x = 0:pi/100:2*pi;
y = sin(x);
plot(x, y);
%[text] Wenn man ein Diagramm mit einem bestimmten Linienstil, einer bestimmten  Markierung und einer bestimmten Farben erstellen möchte, muss folgende Syntax verwendet werden: **`plot(X, Y, LineSpec)`** Tabelle unter diesem [Link](https://de.mathworks.com/help/matlab/ref/plot.html#btzitot_sep_mw_3a76f056-2882-44d7-8e73-c695c0c54ca8).
%[text] Um die Elemente auf der x- und y-Achse zu beschreiben und dem Bild einen Titel zu geben, schreiben wir einfach Folgendes:
xlabel('x_Beschreibung');
ylabel('y_Beschreibung');
title('Titel des Diagramms');

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[output:8ccab912]
%   data: {"dataType":"error","outputData":{"errorType":"runtime","text":"Unable to resolve the name 'prob04.solve'."}}
%---
