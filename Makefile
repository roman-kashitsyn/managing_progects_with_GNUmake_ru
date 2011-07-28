REVISION := 0.1
DOCUMENT := make3_book
OUT      := $(DOCUMENT)_r$(REVISION).pdf
README   := README.md
LICENSE  := LICENSE
RELEASE  := $(DOCUMENT)_r$(REVISION).zip

# TeX files
MAIN        := main
latex_src   := ./src/latex
figures_dir := $(latex_src)/figures
main_tex    := $(latex_src)/$(MAIN).tex
figures     := $(addsuffix .eps,$(basename $(wildcard $(figures_dir)/*.mp)))
tex_files   := $(shell find $(latex_src) -name '*.tex' -type f -print)

# temporary files
tmp_suffixes := aux toc log ilg ind idx pdf dvi out
tmp_files    := $(addprefix $(MAIN).,$(tmp_suffixes))
tmp_files    += $(figures)
tmp_files    += $(OUT) $(RELEASE)

# tools
ZIP        := zip
LN         := ln
MV         := mv
RM         := rm
LATEX      := pdflatex
MPOST      := mpost
MAKE_INDEX := makeindex
RM_FLAGS   := -rf


$(MAIN).pdf: $(tex_files) $(MAIN).ind
	$(LATEX) $(main_tex)

.PHONY: release
release: $(RELEASE)

$(RELEASE): $(OUT) $(README) $(LICENSE)
	@echo packing release files [$^]...
	$(ZIP) $@ $^

$(OUT): $(MAIN).pdf
	$(LN) $< $@

$(MAIN).ind: $(MAIN).idx
	$(MAKE_INDEX) $(MAIN).idx

$(MAIN).idx: $(tex_files) $(figures)
	$(LATEX) $(main_tex)

$(figures_dir)/%.eps: $(figures_dir)/%.mp
	@echo making figure $@...
	$(MPOST) $^
	$(MV) $*.1 $@
	$(RM) $(RM_FLAGS) $*.log

.PHONY: help
help:
	@echo ==================================================
	@echo 'Managing Projects With GNU Make build help'
	@echo ==================================================
	@echo 'Target                   Purpose'
	@echo --------------------------------------------------
	@echo 'main.pdf (default)       Build pdf version of the book'
	@echo 'help                     Show this help'
	@echo 'release                  Build zip archive with pdf file'
	@echo 'clean                    Remove all generated files'
	@echo 'count                    Count LOC of the project'

.PHONY: count
count:
	@echo counting lines of latex code:
	@find . -name '*.tex' -print | xargs wc -l

.PHONY: clean
clean:
	$(RM) $(RM_FLAGS) $(tmp_files)
