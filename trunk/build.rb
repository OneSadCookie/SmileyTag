require 'rbuild-bundle'
require 'rbuild-cfamily'

if !File.exists?('Lua/lua-5.0/lib/liblua.a')
    system('cd Lua && tar -xzf lua-5.0.tar.gz')
    system('cd Lua/lua-5.0 && make')
end

objects = build_objects(:sources => Dir['Source/*.m'],
                        :extra_cflags => '-ILua/lua-5.0/include',
                        :extra_dependencies => ['Lua/lua-5.0'])

build_bundle(:bundle_name => 'Smiley Tag.app',
             :resources_directory => 'Resources',
             :info_plist_file => 'Info.plist')

build_link(:executable => 'Smiley Tag.app/Contents/MacOS/Smiley Tag',
           :objects => objects,
           :archives => ['Lua/lua-5.0/lib/liblua.a',
                         'Lua/lua-5.0/lib/liblualib.a'],
           :frameworks => ['Cocoa', 'OpenGL', 'QuickTime'],
           :extra_dependencies => ['Smiley Tag.app/Contents/MacOS'])
