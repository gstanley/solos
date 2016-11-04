# read symbols
# generate call graph
# select ruby, javascript, java parser

require "find"
require "treetop"

["ruby", "javascript", "java"].each {|name| Treetop.load("./#{name}")}

def parse_files(path)
  Find.find(path) do |f|
    next if FileTest.directory?(f)
    dir, file = File.split(f)
    case File.extname(f)
    when ".rb"
      puts f
    when ".js"
    when ".java"
    end
  end
end

