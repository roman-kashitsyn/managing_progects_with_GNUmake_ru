REVISION := 0.1
DOCUMENT := make3_book
OUT      := $(DOCUMENT)_r$(REVISION).pdf
README   := README
RELEASE  := $(DOCUMENT)_r$(REVISION).zip

# TeX files
MAIN        := main
FIGURES_DIR := figures
figures     := $(addsuffix .eps,$(basename $(wildcard $(FIGURES_DIR)/*.mp)))
tex_files   := $(shell find . -name '*.tex' -type f -print)

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

$(MAIN).pdf: $(tex_files) $(MAIN).ind $(figures)
	$(LATEX) $(MAIN).tex

.PHONY: release
release: $(RELEASE)

$(RELEASE): $(OUT) $(README)
	@echo packing release files [$^]...
	$(ZIP) $@ $^

$(OUT): $(MAIN).pdf
	$(LN) $< $@

$(MAIN).ind: $(MAIN).idx
	$(MAKE_INDEX) $(MAIN).idx

$(MAIN).idx: $(tex_files)
	$(LATEX) $(MAIN).tex

$(FIGURES_DIR)/%.eps: $(FIGURES_DIR)/%.mp
	@echo making figure $@...
	$(MPOST) $^
	$(MV) $*.1 $@
	$(RM) $(RM_FLAGS) $*.log

.PHONY: count
count:
	@echo counting lines of latex code:
	@find . -name '*.tex' -print | xargs wc -l

.PHONY: clean
clean:
	$(RM) $(RM_FLAGS) $(tmp_files)
