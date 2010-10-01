MAKEFLAGS := Rr $(shell echo -j$$(((1 + 3 * `sysctl -n hw.ncpu`) / 2)))

export APP := SmileyTag
ARCHS      := ppc i386 x86_64

C_EXTS   := c m
CXX_EXTS := cc cpp cxx c++ mm
SRC_EXTS  = $(C_EXTS) $(CXX_EXTS)
H_EXTS   := h
HXX_EXTS := hh hpp hxx h++

BUNDLE     := $(APP).app
CONTENTS   := $(BUNDLE)/Contents
EXE        := $(CONTENTS)/MacOS/$(APP)
INFO_PLIST := $(CONTENTS)/Info.plist
PKGINFO    := $(CONTENTS)/PkgInfo
NIB        := $(CONTENTS)/Resources/MainMenu.nib

LUA := lua-5.1.4
LUA_SOURCES := $(patsubst %,$(LUA)/src/%.c,lapi lcode ldebug ldo ldump lfunc lgc llex lmem \
	lobject lopcodes lparser lstate lstring ltable ltm  \
	lundump lvm lzio lmathlib lauxlib)

export CFLAGS   := -I$(LUA)/src -Wall -Wextra -Wno-unused-parameter -Wnewline-eof -Werror -O2 -gfull -pipe -mdynamic-no-pic
export CXXFLAGS  = $(CFLAGS) -fno-exceptions -fno-rtti
export LDFLAGS  := $(patsubst %,-framework %,Cocoa OpenGL GLUT)

define find_source #(dir)
$(foreach ext,$(SRC_EXTS),$(wildcard $(1)/*.$(ext)))
endef

export SOURCES := $(filter-out Source/_dummy%,$(call find_source,Source)) $(LUA_SOURCES)
	
THIN_EXES := $(patsubst %,build/%/$(APP),$(ARCHS))

$(LUA_SOURCES): build/luahack

build/luahack: $(LUA).tar.gz
	tar xmzf $(LUA).tar.gz
	mkdir -p $(@D)
	touch $@

build/%/$(APP): $(SOURCES) Makefile Arch.mk
	./choosesdk.rb $* --run "$(MAKE) -f Arch.mk $@ ARCH=$*"

$(EXE): $(THIN_EXES) Makefile
	mkdir -p $(@D)
	lipo $(THIN_EXES) -create -output $@

$(INFO_PLIST): Info.plist Makefile
	mkdir -p $(@D)
	cat $< | perl -pe "s|SVNVERSION|`svn info | \
		grep 'Last Changed Rev' | \
		perl -pe 's|Last Changed Rev: (\d+)|\\1|'`|" > $@

$(PKGINFO): Makefile
	mkdir -p $(@D)
	echo 'APPL????' > $@

$(NIB): MainMenu.xib
	mkdir -p $(@D)
	ibtool $< --compile $@

all: Makefile $(EXE) $(INFO_PLIST) $(PKGINFO) $(NIB)
	rsync -r --del --exclude '.*' --exclude '*.nib' Resources $(CONTENTS)/

$(APP).dmg: Makefile all
	dmgcanvas $(APP).dmgCanvas $(APP).dmg -leopard-compatible

clean:
	rm -rf build $(BUNDLE) $(LUA)

.DEFAULT_GOAL := all
.PHONY: all clean
