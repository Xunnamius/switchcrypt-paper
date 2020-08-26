BIBTEX=bibtex
PDFLATEX=pdflatex -shell-escape
GHOSTSCRIPT=\gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dEmbedAllFonts=true

TEX-FILES = $(wildcard *.tex)
BIB-FILES = $(wildcard *.bib)
FIG-FILES = $(wildcard figs/*.png data/*.tex data/*.dat)
PAPER = dickens-switchcrypt

.PHONY: all for-vscode generate-paper generate-pdfs generate-pdf save-temporary clean

all: generate-pdfs $(PAPER) save-temporary
for-vscode: generate-pdfs

generate-paper: ${TEX-FILES} ${BIB-FILES} ${FIG-FILES}
	mkdir -p out
	$(PDFLATEX) _${PAPER}
	$(BIBTEX) _${PAPER}
	$(PDFLATEX) _${PAPER}
	$(PDFLATEX) _${PAPER}

generate-pdf: generate-pdfs
generate-pdfs: generate-paper

save-temporary:
	mkdir -p out
	find . -name '*.gz' -type f -delete
	find . -name '*.aux*' -type f -delete
	find . -name '*.blg' -type f -delete
	find . -name '*.bbl' -type f -delete
	find . -name '*.out' -type f -delete
	find . -name '*.log' -type f -delete
	find . -name '*.xml' -type f -delete
	find . -name '*.fls' -type f -delete
	find . -name '*.toc' -type f -delete
	find . -name '*.lot' -type f -delete
	find . -name '*.lof' -type f -delete
	find . -name '*.fdb*' -type f -delete
	find . -name '*.blx*' -type f -delete
	find out -name '_minted*' -type d -delete
	find . -name '_minted*' -type d -exec mv -f -t out {} +

$(PAPER): _$(PAPER).pdf
	$(GHOSTSCRIPT) -sOutputFile=$(PAPER).pdf -f _$(PAPER).pdf

clean:
	rm -rf *.gz *.aux* *.blg *.bbl *.out *.log *.xml *.fls *.toc *.lot *.lof *.fdb* *blx* _minted* out
	mkdir out
	touch out/.gitkeep

