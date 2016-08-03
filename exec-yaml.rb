require "yaml"

def load_yaml_file(name)
  YAML.load(File.read(name))
end

# dependent on load_yaml_file
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

# dependent on merge_defaults
def populate_line_numbers(source)
  line_number = 1
  source.map do |elem|
    if elem["src"]
      if elem["line"]
        line_number = elem["line"]
      else
        elem["line"] = line_number
      end
      line_number += 1
    end
    elem
  end
end

# dependent on populate_line_numbers
def show_source(source, line_numbers)
  source.each do |elem|
    if elem["src"]
      if line_numbers
        print "#{elem["line"]}: "
      end
      puts elem["src"]
    end
  end
end

# dependent on merge_defaults
def show_gen_source(source)
  source.each do |elem|
    if elem["src"]
      puts elem["src"]
    end
  end
end

#def exec_line(source, line)
#  line_number = 1
#  source.each do |elem|
#    if elem["src"]
#      if line_numbers
#        line_number += 1
#      end
#    end
#  end
#end

