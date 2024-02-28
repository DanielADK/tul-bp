FILE := main
DIAGRAMS_DIR := ./diagrams
IMG_DIR := ./images
PLANTUML_JAR := ./vendor/plantuml.jar
SOURCES := $(wildcard $(DIAGRAMS_DIR)/*.txt)
TARGETS := $(patsubst $(DIAGRAMS_DIR)/%.txt,$(IMG_DIR)/%.png,$(SOURCES))

all: 
	$(MAKE) -j8 deps
	$(MAKE) spellcheck 
	$(MAKE) compile

deps: $(TARGETS)
	
$(IMG_DIR)/%.png: $(DIAGRAMS_DIR)/%.txt
	@mkdir -p $(IMG_DIR)
	java -jar $(PLANTUML_JAR) -o ../$(IMG_DIR) $<

clean: clean-tex clean-pdf clean-diagrams

clean-tex:
	rm -rf ./**/*.out
	rm -rf ./**/*.aux
	rm -rf ./**/*.bbl
	rm -rf ./**/*.aux
	rm -rf ./**/*.bbl 
	rm -rf ./**/*.blg ./**/*.log ./**/*toc ./**/*.ptb ./**/*.tod ./**/*.fls ./**/*.fdb_latexmk ./**/*.lof ./**/*.vrb ./**/*.nav ./**/*.snm ./**/*.bcf ./**/*.bak

clean-pdf: 
	rm -f *.pdf

clean-diagrams:
	rm -f $(TARGETS)

spellcheck:
	aspell --lang=cs --home-dir=. --personal=./dictionary.txt --encoding=utf-8 -t -c $(FILE).tex || true; \

compile:
	xelatex $(FILE)
	biber $(FILE)
	xelatex $(FILE)
	xelatex $(FILE)
	make clean-tex
