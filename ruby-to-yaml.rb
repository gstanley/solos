# export yaml for ruby ast

require "ripper"
require "yaml"

def export_yaml(ast)
  ast.to_yaml
end

def file_to_ast(file)
  src = File.read(file)
  Ripper.sexp(src)
end

if __FILE__ == $0
  ARGV.each do |file|
    puts file + ":"
    puts export_yaml(file_to_ast(file))
  end
end
