REVISION := 0.1
DOCUMENT := make3_book
OUT      := $(DOCUMENT)_r$(REVISION).pdf
README   := README.md
LICENSE  := LICENSE
RELEASE  := $(DOCUMENT)_r$(REVISION).zip

ORIGIN_DIR := origin

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
MKDIR      := mkdir
LATEX      := pdflatex
SHELL      := bash
MPOST      := mpost
MAKE_INDEX := makeindex
RM_FLAGS   := -rf
PYTHON     := python
WGET       := wget

# miscellaneous
LATEX_ARGS := --interaction batchmode
SILENCE    := &>/dev/null

define parse-log
  $(PYTHON) ./src/python/parse-log.py $1
endef

define insure-dir-exists
  if [ ! -d $1 ]; then $(MKDIR) $1; fi
endef

define insure-prog-exists
  echo -n "Checking for $1... "; \
  if which $1 &> /dev/null;      \
    then echo "Ok. :]";          \
    else echo "NOT FOUND.";      \
         echo "Exiting. :[";     \
         exit 1;                 \
  fi
endef

define download-file-to-dir
  $(WGET) --directory-prefix $2 $1;
endef

define original-chapter
  http://oreilly.com/catalog/make3/book/ch$(1).pdf
endef

$(MAIN).pdf: $(tex_files) $(MAIN).ind
	$(LATEX) $(LATEX_ARGS) $(main_tex) $(SILENCE)
	$(call parse-log,$(MAIN).log)

.PHONY: release
release: $(RELEASE)

$(RELEASE): $(OUT) $(README) $(LICENSE)
	@echo packing release files [$^]...
	$(ZIP) $@ $^

$(OUT): $(MAIN).pdf
	$(LN) $< $@

$(MAIN).ind: $(MAIN).idx
	$(MAKE_INDEX) $< $(SILENCE)

$(MAIN).idx: $(tex_files) $(figures)
	$(LATEX) $(LATEX_ARGS) $(main_tex) $(SILENCE)

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
	@echo 'download-origin          Download original of the book'
	@echo '                         Requires wget and ~4.5M disk space'

.PHONY: count
count:
	@echo counting lines of latex code:
	@find . -name '*.tex' -print | xargs wc -l

.PHONY: download-origin
download-origin:
	$(call insure-prog-exists,$(WGET))
	$(call insure-dir-exists,$(ORIGIN_DIR))
	for ch in {01..12}; do                                           \
	  $(call download-file-to-dir,$(call original-chapter,"$${ch}"), \
                                      $(ORIGIN_DIR))                     \
	done;

.PHONY: clean
clean:
	$(RM) $(RM_FLAGS) $(tmp_files)
