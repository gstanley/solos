require 'find'
require 'ptools'
require 'byebug'

# todo
#   source directory
#   name pattern
#   search pattern
#     case sensitivity
#   line length limit
#   sort

# find ~ -type f 2>/dev/null |xargs grep "eschulte" 2>/dev/null |less
def search(dir, name_pattern, search_pattern)
  Find.find(ENV["HOME"]).each do |pathname|
    if FileTest.directory?(pathname)
      if File.basename(pathname)[0] == ?.
        Find.prune
      else
        next
      end
    else
      binary = File.binary?(pathname)
      puts pathname + ' ' + (binary ? 't' : 'f')
      debugger
      File.readlines(pathname).each do |line|
        puts line unless binary
      end
    end
  end
end

def binary_line?(line)
end

search(nil, nil, nil)
