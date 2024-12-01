FILE := main
DIAGRAMS_DIR := ./diagrams
IMG_DIR := ./images
PARTS_DIR := ./tex-parts
PLANTUML_JAR := ./vendor/plantuml.jar
SOURCES := $(wildcard $(DIAGRAMS_DIR)/*.puml)
TARGETS := $(patsubst $(DIAGRAMS_DIR)/%.puml,$(IMG_DIR)/%.png,$(SOURCES))
TEX_PARTS := $(wildcard $(PARTS_DIR)/*.tex)

all: 
	$(MAKE) -j8 deps
	$(MAKE) spellcheck 
	$(MAKE) compile

deps: $(TARGETS)
	
$(IMG_DIR)/%.png: $(DIAGRAMS_DIR)/%.puml
	@mkdir -p $(IMG_DIR)
	java -jar $(PLANTUML_JAR) -o ../$(IMG_DIR) $<

clean: clean-tex clean-pdf clean-diagrams

clean-tex:
	rm -rf ./**/*.out ./**/*.aux ./**/*.bbl ./**/*.aux ./**/*.bbl ./**/*.blg ./**/*.log ./**/*toc ./**/*.ptb ./**/*.tod ./**/*.fls ./**/*.fdb_latexmk ./**/*.lof ./**/*.vrb ./**/*.nav ./**/*.snm ./**/*.bcf ./**/*.bak
	rm -rf ./*.out ./*.aux ./*.bbl ./*.aux ./*.bbl ./*.blg ./*.log ./*toc ./*.ptb ./*.tod ./*.fls ./*.fdb_latexmk ./*.lof ./*.vrb ./*.nav ./*.snm ./*.bcf ./*.bak ./*.idx ./*.run.xml ./*.xdv

clean-pdf: 
	rm -f *.pdf

clean-diagrams:
	rm -f $(TARGETS)

spellcheck:
	for texfile in $(TEX_PARTS); do \
		aspell --lang=cs,en --home-dir=. --personal=./dictionary.txt --encoding=utf-8 -t -c $$texfile || true; \
		python3 typo-correct.py $$texfile; \
	done

	aspell --lang=cs --home-dir=. --personal=./dictionary.txt --encoding=utf-8 -t -c $(FILE).tex || true; \
	python3 typo-correct.py $(FILE).tex

compile:
	xelatex $(FILE)
	biber $(FILE)
	xelatex $(FILE)
	xelatex $(FILE)
	make clean-tex
