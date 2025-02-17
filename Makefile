# https://sourceforge.net/projects/acme-crossass/
ACME=acme

# https://github.com/mach-kernel/cadius
CADIUS=cadius

BUILDDIR=build
SOURCES=$(wildcard src/*.a)
EXE=$(BUILDDIR)/IMPROB.SYSTEM\#FF2000
DATA=$(wildcard res/*)
DISKVOLUME=NEW.DISK
BUILDDISK=$(BUILDDIR)/$(DISKVOLUME).po

.PHONY: clean mount all

$(BUILDDISK): $(DATA) $(EXE)

$(EXE): $(SOURCES) | $(BUILDDIR)
	$(ACME) -r build/improbable.lst src/improbable.a
	$(CADIUS) REPLACEFILE "$(BUILDDISK)" "/$(DISKVOLUME)/" "$(EXE)" -C
	@touch "$@"

$(DATA): $(BUILDDIR)
	$(CADIUS) REPLACEFILE "$(BUILDDISK)" "/$(DISKVOLUME)/" "$@" -C
	@touch "$@"

mount: $(BUILDDISK)
	@open "$(BUILDDISK)"

clean:
	rm -rf "$(BUILDDIR)"

$(BUILDDIR):
	mkdir -p "$@"
	$(CADIUS) CREATEVOLUME "$(BUILDDISK)" "$(DISKVOLUME)" 800KB -C

all: clean mount

.NOTPARALLEL:
