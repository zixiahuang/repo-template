SUBDIRS = code latex

.PHONY: all clean $(SUBDIRS)

all: $(SUBDIRS)

# latex depends on code so `make -j` builds them in order
latex: code

$(SUBDIRS):
	$(MAKE) -C $@

clean:
	for dir in $(SUBDIRS); do $(MAKE) -C $$dir clean; done
