#!/bin/sh
# Alle Dateien mit Namen der Form „*-*-*_protokoll*.tex“ mit latexmk 
# (eingestellt auf pdflatex) kompilieren. Dabei wird die nicht öffentliche
# Version durch Setzen von \protokollprivatetrue erzeugt.
echo "Kompiliere TeX-Dateien im aktuellen Verzeichnis"
echo "($(pwd))"
echo
find -maxdepth 1 -type f -name '*-*-*_protokoll*.tex' -execdir sh -c '
	echo "Kompiliere {}"
	tex_prefix="\newif\ifprotokollprivate\protokollprivatetrue"
	file="$(basename -- "$0" .tex)"
	latexmk -pdf -silent --jobname="$file"_vertraulich \
		-pdflatex="pdflatex %O \"$tex_prefix\input{$file}\"" \
		"$file"
	echo
' '{}' ';'
# Hilfsdateien entfernen
rm -f *.aux *.log *.out *.toc *.fls *.fdb_latexmk *.synctex.gz

