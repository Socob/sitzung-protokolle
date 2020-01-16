% LaTeX-Klasse für Protokolle der Fachschaft Physik der WWU Münster
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{fsphys-protokoll}[%
	2018/01/24 Protokolle der Fachschaft Physik der WWU Muenster%
]

% Verwendung von KOMA-Script
\LoadClass[
	% Papierformat
	a4paper,
	% Schriftgröße
	12pt,
	% einseitiges Layout
	oneside,
	% Abstand zwischen Absätzen statt Einrücken
	parskip=half-
]{scrartcl}

% Unterscheidung zwischen pdfTeX und LuaTeX
\RequirePackage{iftex}
% Erweiterte Funktionen zur TeX-Programmierung
\RequirePackage{etoolbox}
\ifLuaTeX
	% Einstellungen für Schriftart
	\RequirePackage{fontspec}
	% Silbentrennung, sprachspezifische Einstellungen
	\RequirePackage{polyglossia}
	\setmainlanguage{german}
	% Verbesserte Ligaturen
	\RequirePackage{selnolig}
\else
	% Füge den globalen Optionen „ngerman“ hinzu, um die Sprache global zu
	% setzen. Es reicht nicht, die Option nur babel zu übergeben (z.B. cleveref
	% übernimmt die Sprache dann nicht)
	% ngerman: deutsch (neue deutsche Rechtschreibung)
	\preto\@classoptionslist{ngerman,}
	% Silbentrennung, sprachspezifische Einstellungen
	\RequirePackage{babel}
	% Mögliche darstellbare Zeichen (Umlaute, Sonderzeichen…)
	\RequirePackage[T1]{fontenc}
	% Zeichenkodierung der TeX-Datei
	\RequirePackage[utf8]{inputenc}
	% Schriftart
	\RequirePackage{lmodern}
	% führt Befehle für Sonderzeichen ein
	\RequirePackage{textcomp}
\fi
% Verarbeitung von Optionen der Form <Schlüssel>=<Wert>
\RequirePackage{kvoptions}
% Zeichenketten-Programmierung
\RequirePackage{xstring}
% Erweiterte Möglichkeiten für LaTeX-Umgebungen
\RequirePackage{environ}
% Aufrufen von Kommandozeilen innerhalb von LaTeX
\RequirePackage{shellesc}
% Detektion des Betriebssystems
\RequirePackage{ifplatform}

% Seitenränder
\RequirePackage[
	left=1.8cm,
	right=1.8cm,
	top=1.8cm,
	bottom=1.5cm
]{geometry}
% Besseres Schriftbild
\RequirePackage{microtype}
% Formatierung von Daten
\RequirePackage[useregional]{datetime2}
% Für Kopf-/Fußzeile etc.
\RequirePackage[automark]{scrlayer-scrpage}
% Farben ermöglichen
\RequirePackage{xcolor}
% Paket für Bilder-Einbindung (EPS, PNG, JPG, PDF)
\RequirePackage{graphicx}
% Schönere Brüche in Textzeilen
\RequirePackage{xfrac}
% Zur einfachen Eingabe von Zahlen mit Einheiten
\RequirePackage{siunitx}
% schönere Aufzählungen
\RequirePackage{enumitem}
% „Schlaue“ Anführungszeichen
\RequirePackage{csquotes}
% für extra lange Tabellen
\RequirePackage{longtable}
% Zum Einbinden von Zitaten oder Textdateien
\RequirePackage{listingsutf8}

% Links, Verweise können im PDF angeklickt werden (möglichst am Ende laden!)
\RequirePackage[bookmarksnumbered, unicode]{hyperref}
% Verweise mit vielen Funktionen (nach hyperref laden!)
\RequirePackage{cleveref}

%%% Einstellungen
% Mehr Freiraum in Tabellen
\renewcommand{\arraystretch}{1.1}
% listings: Einstellungen für Sonderzeichen
\lstset{
	columns=flexible,
	breaklines=true,
	basicstyle=\ttfamily,
	literate=
		{ö}{{\"o}}1
		{ä}{{\"a}}1
		{ü}{{\"u}}1
		{Ö}{{\"O}}1
		{Ä}{{\"A}}1
		{Ü}{{\"U}}1
		{ß}{{\ss}}1
		{§}{{\S}}1
}
% csquotes: Anführungszeichen automatisch umwandeln
\MakeOuterQuote{"}
% siunitx: Einstellungen
\sisetup{
	locale=DE,
	mode=text,
	binary-units,
	quotient-mode=fraction,
	per-mode=fraction,
	fraction-function=\sfrac,
	detect-weight
}
\DeclareSIUnit{\euro}{€}
% enumitem: Einstellungen für Aufzählungen
\setlist{
	% Linke Einrückung
	leftmargin=2em
}
% hyperref: Einstellungen
\hypersetup{
	% Links/Verweise mit Kasten der Dicke 0.5pt versehen
	pdfborder={0 0 0.5}
}
% cleveref: Einstellungen für Verweise
% Auf Abschnitte (\section) als TOP/Anhang verweisen
\crefname{section}{\protokollsecprefix}{\ifstr{\protokollsecprefix}{\appendixname}{Anhänge}{\appendixname}}
\Crefname{section}{\protokollsecprefix}{\ifstr{\protokollsecprefix}{\appendixname}{Anhänge}{\appendixname}}

% Kopf- und Fußzeile zunächst leeren
\clearscrheadfoot
% Kopfzeile links
\ihead{\protokollheader}
% Kopfzeile rechts
\ohead{\pagemark}
% Dokument mit Kopf-/Fußzeile
\pagestyle{scrheadings}

%%% Definitionen
% Semantische Aliase für Textformatierungsbefehle
\let\strong=\textbf
\let\propername=\textit
\let\code=\texttt
\newcommand*{\email}[1]{\href{mailto:#1}{\texttt{#1}}}
\newcommand*{\Hrule}{\medskip\hrule\vspace{\dimexpr\medskipamount-\parskip}}
\newcommand{\protokollunterbrechung}[1]{%
	\Hrule
	\begin{center}
		#1
	\end{center}
	\Hrule
}

% Umgebung für vertrauliche Teile des Protokolls
\providebool{protokollprivate}
\ifdefined\protokollprivatese
	\protokollprivatetrue
\else\ifprotokollprivate
\else
	% Falls shell-escape aktiviert ist: direkt auch das vertrauliche
	% Protokoll erzeugen
	% Shell-Syntax variiert zwischen Betriebssystemen
	\ifwindows
		\ShellEscape{%
			latexmk -pdf --jobname="\jobname_vertraulich" %
				-pdflatex="pdflatex \@percentchar O %
				\def\string\protokollprivatese{1} %
				\string\input{\jobname}" %
				"\jobname"%
		}
	\else
		\ShellEscape{%
			latexmk -pdf --jobname='\jobname_vertraulich' %
				-pdflatex='pdflatex \@percentchar O %
				'"'"'\def\string\protokollprivatese{1} %
				\string\input{\jobname}'"'" %
				'\jobname'%
		}
	\fi
\fi\fi
\newcommand*{\protokoll@privatestyle}{%
	\let\shapedefault=\itdefault
	\itshape
}
% Inhalt von Umgebung „nichtoeffentlich“ erscheint nur im vertraulichen
% Protokoll; im öffentlichen Protokoll wird ein Hinweis ausgegeben
\newcommand*{\protokoll@privatemsg}{%
	\begin{list}{}{\rightmargin\leftmargin\protokoll@privatestyle}
		\item An dieser Stelle ist ein Teil des Protokolls nicht öffentlich.
	\end{list}
}
% Version mit Stern: Im nicht öffentlichen Protokoll wird der Inhalt direkt
% ausgegeben
\NewEnviron{nichtoeffentlich*}{%
	\ifprotokollprivate
		{\protokoll@privatestyle\BODY}%
	\else
		\protokoll@privatemsg
	\fi
}
% Version ohne Stern: Im nicht öffentlichen Protokoll wird der nicht öffentliche
% Abschnitt zusätzlich durch die Überschrift „Nicht öffentlich:“ markiert
\NewEnviron{nichtoeffentlich}{%
	\ifprotokollprivate
		{\par\protokoll@privatestyle{\parshape0%
		\textbf{Nicht öffentlich:}\par}%
		\BODY}%
	\else
		\protokoll@privatemsg
	\fi
}
% Inhalt von Umgebung „nuroeffentlich“ erscheint nur im öffentlichen Protokoll
\NewEnviron{nuroeffentlich}{%
	\ifprotokollprivate
	\else
		{\BODY}%
	\fi
}

% falls \protokolldatum min. 2 Bindestriche enthält: davon ausgehen,
% dass das Datum im Format JJJJ-MM-TT eingegeben wurde und \DTMdate,
% verwenden; ansonsten einfach nur \protokolldatum ausgeben
\newcommand*{\protokollsetformatteddate}{%
	\IfSubStr[2]{\protokolldatum}{-}
		{\DTMsavedate{protokolldate}{\protokolldatum}\DTMmakeglobal{protokolldate}%
		\newcommand*{\protokollformatteddate}{\DTMusedate{protokolldate}}}
		{\newcommand*{\protokollformatteddate}{\protokolldatum}}%
}
% Verarbeiten von Teilnehmerlisten
\newcounter{protokollcounter}
\newcommand*{\protokoll@parse}[1]{\@for\@tempa:=#1\do{\stepcounter{protokollcounter}}}
\newcommand*{\protokoll@listcount}[1]{\setcounter{protokollcounter}{0}\protokoll@parse{#1}\arabic{protokollcounter}}

% Allgemeine Variablen
\newcommand*{\protokolldatum}{00.00.0000}
\newcommand*{\protokollbeginn}{N/A}
\newcommand*{\protokollende}{N/A}
\newcommand*{\protokollant}{NN}
\newcommand*{\protokollort}{N/A}
\newcommand*{\protokollsecprefix}{TOP}
\newcommand*{\protokollanwesend}{NN}
\newcommand*{\protokollweitere}{NN}

% Bereitstellung von Werten am Ende der Präambel, nach Definition durch Nutzer
\AtEndPreamble{
	% Formatiertes Datum
	\protokollsetformatteddate
	% Anzahl der Anwesenden
	\newcounter{protokollanwesend}
	\protokoll@parse{\protokollanwesend}
	\setcounter{protokollanwesend}{\value{protokollcounter}}
	\newcommand*{\protokollanzahlanwesend}{\arabic{protokollanwesend}}
	% Anzahl der weiteren Anwesenden
	\newcounter{protokollweitere}
	\protokoll@parse{\protokollweitere}
	\setcounter{protokollweitere}{\value{protokollcounter}}
	\newcommand*{\protokollanzahlweitere}{\arabic{protokollweitere}}
}

%%% Titelseite, Inhaltsverzeichnis und Überschriften
%%% Unterscheidung der verschiedenen Sitzungen (FSV, FSR)
% Anpassen der Überschriften
\renewcommand*{\sectionformat}{\protokollsecprefix~\thesection:\enskip}
\renewcommand*{\subsectionformat}{\protokollsecprefix~\thesubsection:\enskip}
\renewcommand*{\subsubsectionformat}{\protokollsecprefix~\thesubsubsection:\enskip}
% Anpassen des Inhaltsverzeichnisses
\newcommand*{\protokolltocformat}[1]{{\let\autodot=:\protokollsecprefix~#1\enskip}}
\RedeclareSectionCommands[
	tocentrynumberformat=\protokolltocformat,
	tocdynnumwidth
]{section,subsection,subsubsection}
% Im Anhang nicht mehr „TOP“, sondern „Anhang“ vor Überschriften schreiben
% (im Text und im Inhaltsverzeichnis)
\newcommand*{\appendixmore}{%
	\renewcommand*{\protokollsecprefix}{\appendixname}%
	\addtocontents{toc}{\protect\renewcommand*{\protect\protokollsecprefix}{\appendixname}}%
}

\SetupKeyvalOptions{prefix=protokoll@}
% Option „sitzung“: Unterscheiden zwischen Protokoll für
% FSR-Sitzung oder (konstituierende) FSV-Sitzung
\DeclareStringOption[fsr]{sitzung}

\newcommand*{\protokollentwurf}{
    % Angelehnt an https://tex.stackexchange.com/a/400998 von esdd
    \usepackage{expl3}
    \ExplSyntaxOn
    \newcommand\watermark[1]
    {\makebox[0pt][c]
        {\scalebox{3.1}% scaling
        {\rotatebox[origin=bc]{50}% rotating
            {\Huge\bfseries\textcolor{lightgray}% font settings
                {\watermarktext}{}
    }}}}
    \ExplSyntaxOff
    \newcommand\watermarktext{\textbf{ENTWURF}}

    \DeclareNewLayer[
    background,
    %textarea,
    mode=picture,
    contents={\putC{\watermark{\the\value{page}}}}
    ]{watermark}
    \AddLayersToPageStyle{@everystyle@}{watermark}
}

\DeclareVoidOption{entwurf}{\protokollentwurf}

\ProcessKeyvalOptions*
%% FSR-Sitzung
\ifstr{\protokoll@sitzung}{fsr}{
	\newcommand*{\protokollfehlend}{NN}
	% Unterscheidung öffentlich/nicht öffentlich
	\ifprotokollprivate
		\newcommand*{\protokolltitle}{Protokoll der Sitzung des Fachschaftsrats\\(mit vertraulichem Teil)}
		\newcommand*{\protokoll@hypertitle}{(Vertrauliches) Protokoll der Sitzung des Fachschaftsrats vom \protokollformatteddate}
		\newcommand*{\protokollheader}{\strong{Vertrauliches} Protokoll der FSR-Sitzung vom \protokollformatteddate}
	\else
		\newcommand*{\protokolltitle}{Protokoll der Sitzung des Fachschaftsrats}
		\newcommand*{\protokoll@hypertitle}{Protokoll der Sitzung des Fachschaftsrats vom \protokollformatteddate}
		\newcommand*{\protokollheader}{Protokoll der FSR-Sitzung vom \protokollformatteddate}
	\fi

	% \hypersetup kann erst nach Verarbeitung des Datums verwendet werden.
	% Die Redefinition durch den Nutzer liegt erst am Ende der Präambel vor.
	\AtEndPreamble{
		\hypersetup{
			pdftitle={\protokoll@hypertitle},
			pdfauthor={Fachschaftsrat Physik der WWU Münster, \protokollant},
			pdfsubject={Fachschaftssitzung},
			pdfkeywords={WWU Münster, Fachschaft Physik, Fachschaftsrat, Sitzung, Protokoll}
		}
	}

	\newcommand{\protokoll@infotable}{%
		\begin{longtable}{|p{5.5cm}|p{9.5cm}|}
			\hline
			\endfirsthead
			\textbf{Beginn:}    \protokollbeginn &
			\textbf{Ende:}      \protokollende \\
			\hline
			\textbf{Protokollant:} &
			\protokollant \\
			\hline
			\multicolumn{2}{|p{15cm}|}{\textbf{Anwesende Mitglieder des FSR (\protokoll@listcount{\protokollanwesend}):}} \\
			\multicolumn{2}{|p{15cm}|}{\raggedright\protokollanwesend} \\
			\hline
			\multicolumn{2}{|p{15cm}|}{\textbf{Entschuldigte Mitglieder des FSR (\protokoll@listcount{\protokollfehlend}):}} \\
			\multicolumn{2}{|p{15cm}|}{\raggedright\protokollfehlend} \\
			\hline
			\multicolumn{2}{|p{15cm}|}{\textbf{Weitere Anwesende  (\protokoll@listcount{\protokollweitere}):}} \\
			\multicolumn{2}{|p{15cm}|}{\raggedright\protokollweitere} \\
			\hline
		\end{longtable}
	}
}{
%% FSV-Sitzung
\ifstr{\protokoll@sitzung}{fsv}{
	\newcommand*{\protokolltitle}{Protokoll der Sitzung der Fachschaftsvertretung}
	\newcommand*{\protokoll@hypertitle}{Protokoll der Sitzung der Fachschaftsvertretung vom \protokollformatteddate}
	\newcommand*{\protokollheader}{Protokoll der FSV-Sitzung vom \protokollformatteddate}

	% \hypersetup kann erst nach Verarbeitung des Datums verwendet werden.
	% Die Redefinition durch den Nutzer liegt erst am Ende der Präambel vor.
	\AtEndPreamble{
		\hypersetup{
			pdftitle={\protokoll@hypertitle},
			pdfauthor={Fachschaftsvertretung Physik der WWU Münster, \protokollant},
			pdfsubject={Fachschaftssitzung},
			pdfkeywords={WWU Münster, Fachschaft Physik, Fachschaftsvertretung, Sitzung, Protokoll}
		}
	}

	\newcommand{\protokoll@infotable}{%
		\begin{longtable}{|p{5.5cm}|p{9.5cm}|}
			\hline
			\endfirsthead
			\textbf{Beginn:}    \protokollbeginn &
			\textbf{Ende:}      \protokollende \\
			\hline
			\textbf{Protokollant:} &
			\protokollant \\
			\hline
			\multicolumn{2}{|p{15cm}|}{\textbf{Anwesende Mitglieder der Fachschaftsvertretung (\protokoll@listcount{\protokollanwesend}):}} \\
			\multicolumn{2}{|p{15cm}|}{\raggedright\protokollanwesend} \\
			\hline
			\multicolumn{2}{|p{15cm}|}{\textbf{Weitere Anwesende (\protokoll@listcount{\protokollweitere}):}} \\
			\multicolumn{2}{|p{15cm}|}{\raggedright\protokollweitere} \\
			\hline
		\end{longtable}
	}
}{
%% Konstituierende FSV-Sitzung
\ifstr{\protokoll@sitzung}{fsv-konstituierend}{
	\newcommand*{\protokolltitle}{Protokoll zur konstituierenden Sitzung der Fachschaftsvertretung Physik\\sowie Wahl des Fachschaftsrats}
	\newcommand*{\protokoll@hypertitle}{Protokoll zur konstituierenden Sitzung der Fachschaftsvertretung Physik vom \protokollformatteddate}
	\newcommand*{\protokollheader}{Protokoll zur konstituierenden FSV-Sitzung vom \protokollformatteddate}

	% \hypersetup kann erst nach Verarbeitung des Datums verwendet werden.
	% Die Redefinition durch den Nutzer liegt erst am Ende der Präambel vor.
	\AtEndPreamble{
		\hypersetup{
			pdftitle={\protokoll@hypertitle},
			pdfauthor={Fachschaftsvertretung Physik der WWU Münster, \protokollant},
			pdfsubject={Fachschaftssitzung},
			pdfkeywords={WWU Münster, Fachschaft Physik, Fachschaftsvertretung, konstituierende Sitzung, Wahl, Fachschaftsrat, Protokoll}
		}
	}

	\newcommand{\protokoll@infotable}{%
		\begin{longtable}{|p{5.5cm}|p{9.5cm}|}
			\hline
			\endfirsthead
			\textbf{Beginn:}    \protokollbeginn &
			\textbf{Ende:}      \protokollende \\
			\hline
			\textbf{Protokollant:} &
			\protokollant \\
			\hline
			\textbf{Ort:} &
			\raggedright\arraybackslash
			\protokollort \\
			\hline
			\multicolumn{2}{|p{15cm}|}{\textbf{Anwesende Mitglieder der neuen Fachschaftsvertretung (\protokoll@listcount{\protokollanwesend}):}} \\
			\multicolumn{2}{|p{15cm}|}{\raggedright\protokollanwesend} \\
			\hline
			\multicolumn{2}{|p{15cm}|}{\textbf{Weitere Anwesende (\protokoll@listcount{\protokollweitere}):}} \\
			\multicolumn{2}{|p{15cm}|}{\raggedright\protokollweitere} \\
			\hline
		\end{longtable}
	}
}{% else
	% falscher Wert für Option „sitzung“
	\ClassError{\@currname}{Invalid option: "sitzung=\protokoll@sitzung"}
		{Possible values are: fsr, fsv, fsv-konstituierend.}
}}}

% Ausgabe von Titel und Inhaltsverzeichnis am Beginn des Dokuments
\AtBeginDocument{%
	\begin{center}
		\includegraphics[width=0.75\textwidth]{fs-physik-logo.pdf}

		{\usekomafont{title}\huge
		\protokolltitle
		\par}

		\medskip
		{\usekomafont{date}
		\protokollformatteddate
		\par}

		\medskip
		\protokoll@infotable
	\end{center}
	\tableofcontents
	\clearpage
}

