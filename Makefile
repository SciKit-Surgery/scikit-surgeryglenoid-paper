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

FIGURES = figures/planes.eps \
	  figures/friedman.eps \
	  figures/correctedfried.eps

FIGURES_PNG = 

surgeryglenoid-paper.dvi : surgeryglenoid-paper.tex $(EXTERNALS) $(INPUTS) $(FIGURES)
	latex -halt-on-error surgeryglenoid-paper.tex 
	bibtex surgeryglenoid-paper
	latex -halt-on-error surgeryglenoid-paper
	latex -halt-on-error surgeryglenoid-paper

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

%.pdf : %.tex
	latexmk -pdf $<

%.docx: %.tex surgeryglenoid-paper.bib
	pandoc $< --bibliography=surgeryglenoid-paper.bib -V geometry:margin=2cm -V fontsize:11pt -o $@


dependency_graph.png : dependency_graph.dot
	dot -Tpng dependency_graph.dot -o dependency_graph.png

%.png : %.eps 
	gs -dSAFER -dEPSCrop -r600 -sDEVICE=pngalpha -o $@ $<

%.eps : %.dot
	dot -Tps $< -o $@

%.eps : %.png
	convert $< $@

dependency_graph.dot :
	wget https://github.com/UCL/scikit-surgeryglenoid/raw/master/doc/dependency_graph.dot

clean:
	rm *.acr *.aux *.dvi *.glo *.ist *.lof *.log *.lot *.toc *.pdf *.ps *.out *.blg *.bbl build/surgeryglenoid-paper* build/*.png 
	rm -r build/images

