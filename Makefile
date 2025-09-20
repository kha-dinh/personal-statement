PANDOC = pandoc
# FILTER = --filter pandoc-crossref
# FILTER = --filter pandoc-crossref
TEMPLATE = ./template.latex
CSL = ../../../../support/acm-sig-proceedings.csl
BIB = ../../../../sslab.bib
ENGINE = xelatex

# Collect all Markdown files
MD_FILES := $(wildcard *.md)
PDF_FILES := $(patsubst %.md,output/%.pdf,$(MD_FILES))

FIGURES := $(wildcard tikz/*.pdf)
FIGURE_SRC := $(wildcard tikz/*.tex)

# Default target: build all PDFs into output/
all: $(FIGURES)  $(PDF_FILES)



$(FIGURES):  $(FIGURE_SRC)
	$(MAKE) -C ./tikz

# Rule: compile markdown into PDFs inside output/
output/%.pdf: %.md  
	@mkdir -p output
	$(PANDOC) $< \
	  $(FILTER) \
	  $(PANDOC_FLAGS) \
	  --output=$@ \
	  --pdf-engine=$(ENGINE) \
	  --citeproc \
	  --csl=$(CSL) \
	  --number-sections \
	  --bibliography=$(BIB)

clean:
	rm -f output/*.pdf

.PHONY: clean watch tikz
