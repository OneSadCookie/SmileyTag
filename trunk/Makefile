CC = /usr/bin/gcc-3.3
TAR = /sw/bin/tar
UPLOAD = /usr/bin/scp
RM = /bin/rm
STRIP = /usr/bin/strip
PERL = /usr/bin/perl

IPATHS = -ILua/lua-5.0/include/
WFLAGS = -Wall -W -Wno-unused-parameter -Wnewline-eof -Werror
CFLAGS = -g -Os
LPATHS = -LLua/lua-5.0/lib/
LFLAGS = -framework Cocoa -framework OpenGL -framework QuickTime -llua -llualib

APPNAME = Smiley\ Tag

BUNDLE = $(APPNAME).app
EXECUTABLE = $(BUNDLE)/Contents/MacOS/$(APPNAME)

OBJECTS = $(patsubst %, Build/%.o, $(notdir $(basename $(shell ls Source/*.m))))

all: application

application: bundle $(EXECUTABLE)

bundle:
	mkdir -p  $(BUNDLE)/Contents/MacOS
	echo "APPL????" >  $(BUNDLE)/Contents/PkgInfo
	cp Info.plist  $(BUNDLE)/Contents/
	cp -r Resources  $(BUNDLE)/Contents/
	find $(BUNDLE) -name '.svn' | xargs rm -rf
	find $(BUNDLE) -name '.DS_Store' | xargs rm -f

$(EXECUTABLE): $(OBJECTS)
	$(CC) $(LPATHS) $(LFLAGS) $(OBJECTS) -o $(EXECUTABLE)

Lua/lua-5.0/lib/liblua.a: Lua/lua-5.0.tar.gz
	cd Lua && tar -xzf lua-5.0.tar.gz
	cd Lua/lua-5.0 && make

Build/%.o: Source/%.m Lua/lua-5.0/lib/liblua.a
	$(CC) $(IPATHS) $(WFLAGS) $(CFLAGS) -c $< -o $@

Build/%.d: Source/%.m Lua/lua-5.0/lib/liblua.a
	set -e; $(CC) -MM $(IPATHS) $(CFLAGS) $< | $(PERL) -pe 's/(.*)\.o\:/\1\.o \1.d\:/' > $@

clean:
	rm -f $(OBJECTS) $(OBJECTS:.o=.d)
	rm -rf $(BUNDLE)
	rm -rf Lua/lua-5.0

ifneq ($(MAKECMDGOALS),clean)
-include $(OBJECTS:.o=.d)
endif
