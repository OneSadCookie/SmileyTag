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

build(:targets => ['Smiley Tag.app',
                   'Smiley Tag.app/Contents',
                   'Smiley Tag.app/Contents/MacOS'],
      :command => 'mkdir -p Smiley\ Tag.app/Contents/MacOS',
      :message => "Creating Bundle Hierarchy Smiley Tag.app")

build(:targets => ['Smiley Tag.app/Contents/Resources'],
      :dependencies => ['Smiley Tag.app/Contents',
                        'Resources'],
      :command => 'cp -r Resources Smiley\ Tag.app/Contents/',
      :message => "Copying Resources")

build(:targets => ['Smiley Tag.app/Contents/PkgInfo'],
      :dependencies => ['Smiley Tag.app/Contents'],
      :command => 'echo "APPL????" > Smiley\ Tag.app/Contents/PkgInfo',
      :message => "Creating PkgInfo File Smiley Tag.app/Contents/PkgInfo")
      
build(:targets => ['Smiley Tag.app/Contents/Info.plist'],
      :dependencies => ['Info.plist',
                        'Smiley Tag.app/Contents'],
      :command => 'cp Info.plist Smiley\ Tag.app/Contents/',
      :message => "Copying Info.plist File Smiley Tag.app/Contents/Info.plist")

build(:targets => ['Smiley Tag.app/Contents/MacOS/Smiley Tag'],
      :dependencies => objects +
                      ['Lua/lua-5.0/lib/liblua.a',
                       'Lua/lua-5.0/lib/liblualib.a',
                       'Smiley Tag.app/Contents/MacOS'],
      :command => "#{CC} -o Smiley\\ Tag.app/Contents/MacOS/Smiley\\ Tag #{objects.join(' ')} -LLua/lua-5.0/lib -llua -llualib -framework Cocoa -framework OpenGL -framework QuickTime",
      :message => "Linking Smiley Tag")
