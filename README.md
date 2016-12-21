# sitzung-protokolle
TeX-Vorlage für Protokolle von Sitzungen des Fachschaftsrats (FSR) und der Fachschaftsvertretung (FSV).

## Nicht öffentliche Teile in Protokollen
Mit der Umgebung `\begin{nichtoeffentlich} … \end{nichtoeffentlich}` können
Teile des Protokolls als nicht öffentlich (vertraulich) markiert werden. Im
normalen (öffentlichen) Protokoll erscheint an solchen Stellen nur ein
Hinweis, dass dort ein Teil des Protokolls nicht öffentlich ist.

Sowohl das öffentliche als auch das nicht öffentliche Protokoll können aus
derselben TeX-Datei erzeugt werden. Das öffentliche Protokoll ist jenes, das
bei einem normalen Durchlauf von LaTeX erzeugt wird. Das nicht öffentliche
Protokoll kann auf zwei Wegen erzeugt werden:

1. Man aktiviert im LaTeX-Programm die Option `-shell-escape`. Beim Verarbeiten
   der TeX-Datei werden dann automatisch beide Versionen des Protokolls als
   PDF-Dateien erstellt.
2. Man führt das Skript `nicht_öffentliches_protokoll_erzeugen.sh` (Linux)
   bzw. `nicht_öffentliches_protokoll_erzeugen.bat` (Windows) aus.
