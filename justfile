

statement:
	pandoc personal-statement.md \
	  --filter ../pandoc-crossref  \
	  --output=personal-statement.pdf \
	  --pdf-engine=pdflatex \
	  --citeproc \
	  --template=./template.latex \
	  --csl=../../../support/acm-sig-proceedings.csl \
	  --number-sections \
	  --bibliography=../../../sslab.bib 

proposal:
	pandoc research-proposal.md \
	  --filter ../pandoc-crossref  \
	  --output=research-proposal.pdf \
	  --pdf-engine=pdflatex \
	  --citeproc \
	  --template=./template.latex \
	  --csl=../../../support/acm-sig-proceedings.csl \
	  --number-sections \
	  --bibliography=../../../sslab.bib 
