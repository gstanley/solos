# read symbols
# generate call graph
# select ruby, javascript, java parser

require "find"
require "treetop"

["ruby", "javascript", "java"].each {|name| Treetop.load("./#{name}")}
RUBY_PARSER = RubyParser.new
JAVASCRIPT_PARSER = JavascriptParser.new
JAVA_PARSER = JavaParser.new

def parse_files(path)
  Find.find(path) do |f|
    next if FileTest.directory?(f)
    dir, file = File.split(f)
    puts f
    puts "=" * 40
    contents = File.read(f)
    case File.extname(f)
    when ".rb"
      puts RUBY_PARSER.parse(contents).text_value
    when ".js"
    when ".java"
    end
    puts "=" * 40
  end
end

