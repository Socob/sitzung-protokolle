:: Alle Dateien mit Namen der Form „*-*-*_protokoll*.tex“ mit latexmk 
:: (eingestellt auf pdflatex) kompilieren. Dabei wird die nicht öffentliche
:: Version durch Setzen von \protokollprivatetrue erzeugt.
setlocal
pushd %~dp0

for %%f in (*-*-*_protokoll*.tex) do (
	latexmk -pdf --jobname="%%~nf_vertraulich" ^
		-pdflatex="pdflatex %%O \newif\ifprotokollprivate\protokollprivatetrue\input{%%~nf}" ^
		"%%~nf"
)
:: Hilfsdateien entfernen
del *.aux *.log *.out *.toc *.fls *.fdb_latexmk *.synctex.gz *.cut

popd

