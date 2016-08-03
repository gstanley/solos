require "yaml"

def load_yaml_file(name)
  YAML.load(File.read(name))
end

def merge_defaults(source)
  default = {}
  source.map do |elem|
    if elem["def"]
      default = elem["def"]
      elem
    else
      default.merge(elem)
    end
  end
end

def show_source(source, line_numbers)
  line_number = 1
  source.each do |elem|
    if elem["src"]
      if line_numbers
        print "#{line_number}: "
        line_number += 1
      end
      puts elem["src"]
    end
  end
end

