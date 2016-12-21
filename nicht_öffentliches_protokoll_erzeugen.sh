#!/bin/sh
# Autor: Simon May
# Datum: 2016-11-29
# Alle Dateien mit Namen der Form „*-*-*_protokoll*.tex“ mit latexmk 
# (eingestellt auf pdflatex) kompilieren. Dabei wird die nicht öffentliche
# Version durch Setzen von \protokollprivatetrue erzeugt.
find . -type f -name '*-*-*_protokoll*.tex' -execdir sh -c '
	tex_prefix="\newif\ifprotokollprivate\protokollprivatetrue"
	file=$(basename -- "$0" .tex)
	latexmk -pdf --jobname="$file"_nicht_oeffentlich \
		-pdflatex="pdflatex %O \"$tex_prefix\input{$file}\"" \
		"$file"
' '{}' ';'
# Hilfsdateien entfernen
rm *.aux *.log *.out *.toc *.fls *.fdb_latexmk *.synctex.gz *.cut

