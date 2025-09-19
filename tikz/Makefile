# -------- Tools & opts --------
OUTDIR    := build
LATEXMK   := latexmk
LATEX_OPTS:= -xelatex -shell-escape -halt-on-error -interaction=nonstopmode \
             -file-line-error -outdir=$(OUTDIR)

CONVERT   := magick convert     # or: convert
PDF2SVG   := pdf2svg
DPI       := 300

# Source discovery
TEXSRC := $(wildcard *.tex)
PDFS   := $(patsubst %.tex,$(OUTDIR)/%.pdf,$(TEXSRC))

.PHONY: all pdf png svg clean distclean

# Default: build all PDFs for all .tex files
all: pdf
pdf: $(PDFS)

# Pattern rules
$(OUTDIR)/%.pdf: %.tex | $(OUTDIR)
	$(LATEXMK) $(LATEX_OPTS) $<

$(OUTDIR)/%.png: $(OUTDIR)/%.pdf
	$(CONVERT) -density $(DPI) $< -trim +repage $@

$(OUTDIR)/%.svg: $(OUTDIR)/%.pdf
	$(PDF2SVG) $< $@

# Convenience: build PNG/SVG for every TEX
png: $(patsubst %.tex,$(OUTDIR)/%.png,$(TEXSRC))
svg: $(patsubst %.tex,$(OUTDIR)/%.svg,$(TEXSRC))

# Ensure build dir exists
$(OUTDIR):
	mkdir -p $(OUTDIR)

# Clean aux (keeps outputs), or nuke all
clean:
	$(LATEXMK) -C -outdir=$(OUTDIR)

distclean:
	rm -rf $(OUTDIR)
