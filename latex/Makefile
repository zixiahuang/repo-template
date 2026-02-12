TEX      = pdflatex
BIBTEX   = bibtex
TEXFLAGS = -interaction=nonstopmode

# Resolve \input and \includegraphics from output/ subdirs without ../output/ prefixes
export TEXINPUTS := .:./latex_extras/:../output/numbers/:../output/tables/:../output/figures/:
export BIBINPUTS := ./references/:
export BSTINPUTS := ./references/:

MAIN     = manuscript
SLIDES   = slides

MAIN_SOURCES = $(MAIN).tex \
               latex_extras/packages.tex \
               latex_extras/custom_commands.tex \
               latex_extras/dynamic_tables.tex \
               references/references.bib

SLIDES_SOURCES = $(SLIDES).tex \
                 latex_extras/slides_setup.tex \
                 latex_extras/dynamic_tables.tex \
                 references/references.bib

.PHONY: all clean

all: $(MAIN).pdf $(SLIDES).pdf

$(MAIN).pdf: $(MAIN_SOURCES)
	$(TEX) $(TEXFLAGS) $(MAIN)
	@if grep -q '\\citation' $(MAIN).aux 2>/dev/null; then $(BIBTEX) $(MAIN); fi
	$(TEX) $(TEXFLAGS) $(MAIN)
	$(TEX) $(TEXFLAGS) $(MAIN)

$(SLIDES).pdf: $(SLIDES_SOURCES)
	$(TEX) $(TEXFLAGS) $(SLIDES)
	@if grep -q '\\citation' $(SLIDES).aux 2>/dev/null; then $(BIBTEX) $(SLIDES); fi
	$(TEX) $(TEXFLAGS) $(SLIDES)
	$(TEX) $(TEXFLAGS) $(SLIDES)

clean:
	rm -f $(MAIN).pdf $(SLIDES).pdf *.aux *.bbl *.blg *.log *.out *.toc \
	      *.fdb_latexmk *.fls *.nav *.snm *.vrb *.synctex.gz *.run.xml *-blx.bib
