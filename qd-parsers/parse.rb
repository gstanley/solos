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
    case File.extname(f)
    when ".rb"
      puts f
      puts "=" * 40
      contents = File.read(f)
      puts RUBY_PARSER.parse(contents).text_value
      puts "=" * 40
    when ".js"
      puts f
      puts "=" * 40
      contents = File.read(f)
      puts JAVASCRIPT_PARSER.parse(contents).text_value
      puts "=" * 40
    when ".java"
      puts f
      puts "=" * 40
      contents = File.read(f)
      puts JAVA_PARSER.parse(contents).text_value
      puts "=" * 40
    end
  end
end

if __FILE__ == $0
  parse_files(ARGV[0])
end

