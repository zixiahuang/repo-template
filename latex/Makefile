TEX      = pdflatex
BIBTEX   = bibtex
TEXFLAGS = -interaction=nonstopmode

# Resolve \input and \includegraphics from output/ subdirs without ../output/ prefixes
export TEXINPUTS := .:./latex_extras/:../output/numbers/:../output/tables/:../output/figures/:
export BIBINPUTS := ./references/:

MAIN     = manuscript
SOURCES  = $(MAIN).tex \
           latex_extras/packages.tex \
           latex_extras/custom_commands.tex \
           latex_extras/dynamic_tables.tex \
           references/references.bib

.PHONY: all clean

all: $(MAIN).pdf

$(MAIN).pdf: $(SOURCES)
	$(TEX) $(TEXFLAGS) $(MAIN)
	-$(BIBTEX) $(MAIN)
	$(TEX) $(TEXFLAGS) $(MAIN)
	$(TEX) $(TEXFLAGS) $(MAIN)

clean:
	rm -f $(MAIN).pdf *.aux *.bbl *.blg *.log *.out *.toc *.fdb_latexmk *.fls \
	      *.nav *.snm *.vrb *.synctex.gz *.run.xml *-blx.bib
