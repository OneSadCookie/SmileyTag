require 'rbuild-bundle'

OPTIMIZATION_CFLAGS = '-g -Os'
WARNING_CFLAGS = '-Wall -W -Wno-unused-parameter -Wnewline-eof -Werror'
OTHER_CFLAGS = '-ILua/lua-5.0/include'
CC = "gcc #{OPTIMIZATION_CFLAGS} #{WARNING_CFLAGS} #{OTHER_CFLAGS}"

def cc_dependencies(source_file)
    `#{CC} -MM #{source_file}`.gsub(/\\/, '').split(' ')[1..-1]
end

def object(object_file, source_file)
    build(:targets => [object_file],
          :dependencies => cc_dependencies(source_file),
          :command => "#{CC} -c #{source_file} -o #{object_file}",
          :message => "Compiling #{source_file}")
end

objects = Dir['Source/*.m'].collect do |source_file|
    object_file = "Build/#{File.basename(source_file, '.m')}.o"
    object(object_file, source_file)
    object_file
end

build_bundle(:bundle_name => 'Smiley Tag.app',
             :resources_directory => 'Resources',
             :info_plist_file => 'Info.plist')

build(:targets => ['Smiley Tag.app/Contents/MacOS/Smiley Tag'],
      :dependencies => objects +
                      ['Lua/lua-5.0/lib/liblua.a',
                       'Lua/lua-5.0/lib/liblualib.a',
                       'Smiley Tag.app/Contents/MacOS'],
      :command => "#{CC} -o Smiley\\ Tag.app/Contents/MacOS/Smiley\\ Tag #{objects.join(' ')} -LLua/lua-5.0/lib -llua -llualib -framework Cocoa -framework OpenGL -framework QuickTime",
      :message => "Linking Smiley Tag")
