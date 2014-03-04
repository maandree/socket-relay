# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

PREFIX ?= /usr
BIN ?= /bin
DATA ?= /share
BINDIR ?= $(PREFIX)$(BIN)
DATADIR ?= $(PREFIX)$(DATA)
INFODIR ?= $(DATADIR)/info
LICENSEDIR ?= $(DATADIR)/licenses

COMMAND ?= socket-relay
PKGNAME ?= socket-relay


.PHONY: all
all: doc


.PHONY: doc
doc: info pdf dvi ps

.PHONY: info
info: socket-relay.info
%.info: info/%.texinfo
	makeinfo "$<"

.PHONY: pdf
pdf: socket-relay.pdf
%.pdf: info/%.texinfo
	@mkdir -p obj
	cd obj ; yes X | texi2pdf ../$<
	mv obj/$@ $@

.PHONY: dvi
dvi: socket-relay.dvi
%.dvi: info/%.texinfo
	@mkdir -p obj
	cd obj ; yes X | $(TEXI2DVI) ../$<
	mv obj/$@ $@

.PHONY: ps
ps: socket-relay.ps
%.ps: info/%.texinfo
	@mkdir -p obj
	cd obj ; yes X | texi2pdf --ps ../$<
	mv obj/$@ $@


PHONY: all
clean:
	-rm -r bin obj

