default : surgeryglenoid-paper.pdf

EXTERNALS = acronyms.tex \
	    spmpsci.bst \
	    surgeryglenoid-paper.bib \
	    spie.cls

INPUTS = surgeryglenoid-paper.tex \
	 abstract_250.tex \
	 introduction.tex \
	 methods.tex \
	 results.tex \
	 discussion.tex \
	 acknowledgements.tex \

FIGURES = figures/planes.png \
	  figures/friedman.png \
	  figures/correctedfried.png \
	  figures/dep_graph.png

FIGURES_PNG = 

surgeryglenoid-paper.pdf : surgeryglenoid-paper.tex $(EXTERNALS) $(INPUTS) $(FIGURES)
	latexmk -pdf $<

build/surgeryglenoid-paper.html : surgeryglenoid-paper.tex $(EXTERNALS) $(INPUTS) $(FIGURES_PNG) $(FIGURES)
	latex -halt-on-error surgeryglenoid-paper.tex
	bibtex surgeryglenoid-paper
	htlatex surgeryglenoid-paper.tex "html,html5, charset=utf-8" " -cunihtf -utf8" 
	mv surgeryglenoid-paper*.html build/
	mv surgeryglenoid-paper.4ct surgeryglenoid-paper.4tc build/
	mv surgeryglenoid-paper.css surgeryglenoid-paper.idv build/
	mv surgeryglenoid-paper.lg build/
	mv surgeryglenoid-paper.tmp surgeryglenoid-paper.xref build/
	cp $(FIGURES_PNG) build/
	mkdir build/images
	mv build/default.png build/anisitropic_error.png build/systematic_error.png build/images

%.docx: %.tex surgeryglenoid-paper.bib
	pandoc $< --bibliography=surgeryglenoid-paper.bib -V geometry:margin=2cm -V fontsize:11pt -o $@

figures/graphviz-f4a0d46f29de525cf2512540ebd2f3e3f3356594.png :
	wget -P figures/ https://glenoidplanefitting.readthedocs.io/en/latest/_images/graphviz-f4a0d46f29de525cf2512540ebd2f3e3f3356594.png

clean:
	rm *.acr *.aux *.dvi *.glo *.ist *.lof *.log *.lot *.toc *.pdf *.ps *.out *.blg *.bbl build/surgeryglenoid-paper* build/*.png 
	rm -r build/images

