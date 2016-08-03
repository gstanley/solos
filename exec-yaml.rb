require "yaml"

def load_yaml_file(name)
  YAML.load(File.read(name))
end

