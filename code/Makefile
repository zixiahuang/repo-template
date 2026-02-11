# Root Makefile for code pipeline
# Delegates to task-group sub-Makefiles
#
# Usage:
#   make -C code          # Build all targets
#   make -C code -n       # Dry-run: show what would be built
#   make -C code clean    # Remove all generated outputs

SUBDIRS = # e.g., data_prep estimation simulation tables figures

.PHONY: all clean $(SUBDIRS)

all: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

clean:
	for dir in $(SUBDIRS); do $(MAKE) -C $$dir clean; done
