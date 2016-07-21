# export yaml for javascript ast

require "rubygems"
require "rkelly"
require "yaml"

def export_yaml(ast)
  ast.to_yaml
end

def file_to_ast(file)
  parser = RKelly::Parser.new

  src = File.read(file)
  parser.parse(src).to_sexp
end

if __FILE__ == $0
  ARGV.each do |file|
    puts file + ":"
    puts export_yaml(file_to_ast(file))
  end
end
