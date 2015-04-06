# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

PREFIX ?= /usr
BIN ?= /bin
DATA ?= /share
BINDIR ?= $(PREFIX)$(BIN)
DATADIR ?= $(PREFIX)$(DATA)
DOCDIR ?= $(DATADIR)/doc
INFODIR ?= $(DATADIR)/info
LICENSEDIR ?= $(DATADIR)/licenses

COMMAND ?= socket-relay
PKGNAME ?= socket-relay


.PHONY: default
default: info

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
	@mkdir -p obj/pdf
	cd obj/pdf ; yes X | texi2pdf ../../$<
	mv obj/pdf/$@ $@

.PHONY: dvi
dvi: socket-relay.dvi
%.dvi: info/%.texinfo
	@mkdir -p obj/dvi
	cd obj/dvi ; yes X | $(TEXI2DVI) ../../$<
	mv obj/dvi/$@ $@

.PHONY: ps
ps: socket-relay.ps
%.ps: info/%.texinfo
	@mkdir -p obj/ps
	cd obj/ps ; yes X | texi2pdf --ps ../../$<
	mv obj/ps/$@ $@



.PHONY: install
install: install-base install-info

.PHONY: install
install-all: install-base install-doc

.PHONY: install-base
install-base: install-command install-license

.PHONY: install-command
install-command:
	install -dm755 -- "$(DESTDIR)$(BINDIR)"
	install -m755 src/socket-relay -- "$(DESTDIR)$(BINDIR)/$(COMMAND)"

.PHONY: install-license
install-license:
	install -dm755 -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)"
	install -m644 COPYING LICENSE -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)"

.PHONY: install-doc
install-doc: install-info install-pdf install-ps install-dvi

.PHONY: install-info
install-info: socket-relay.info
	install -dm755 -- "$(DESTDIR)$(INFODIR)"
	install -m644 $< -- "$(DESTDIR)$(INFODIR)/$(PKGNAME).info"

.PHONY: install-pdf
install-pdf: socket-relay.pdf
	install -dm755 -- "$(DESTDIR)$(DOCDIR)"
	install -m644 $< -- "$(DESTDIR)$(DOCDIR)/$(PKGNAME).pdf"

.PHONY: install-ps
install-ps: socket-relay.ps
	install -dm755 -- "$(DESTDIR)$(DOCDIR)"
	install -m644 $< -- "$(DESTDIR)$(DOCDIR)/$(PKGNAME).ps"

.PHONY: install-dvi
install-dvi: socket-relay.dvi
	install -dm755 -- "$(DESTDIR)$(DOCDIR)"
	install -m644 $< -- "$(DESTDIR)$(DOCDIR)/$(PKGNAME).dvi"



.PHONY: uninstall
uninstall:
	-rm -- "$(DESTDIR)$(BINDIR)/$(COMMAND)"
	-rm -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)/COPYING"
	-rm -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)/LICENSE"
	-rmdir -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)"
	-rm -- "$(DESTDIR)$(INFODIR)/$(PKGNAME).info"
	-rm -- "$(DESTDIR)$(DOCDIR)/$(PKGNAME).pdf"
	-rm -- "$(DESTDIR)$(DOCDIR)/$(PKGNAME).ps"
	-rm -- "$(DESTDIR)$(DOCDIR)/$(PKGNAME).dvi"



PHONY: all
clean:
	-rm -r obj socket-relay.{info,pdf,ps,dvi}

