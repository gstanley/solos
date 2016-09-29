require "strscan"
require "byebug"

$writes = []
$reads = []
$controls = []
$follows = []
$lines = []
$current_line = 1

def write(line, name)
  $writes << {line: line, name: name}
end

def read(line, name)
  $reads << {line: line, name: name}
end

def control(controller, target)
  $controls << {controller: controller, target: target}
end

def follow(line, pnext)
  $follows << {line: line, pnext: pnext}
end

def source(line, text)
  $lines << {line: line, text: text}
end

def data_dep?(controller_line, target_line)
  $writes.any? {|w| data_dep_for_variable?(controller_line, target_line, w[:name])}
end

def data_dep_for_variable?(controller_line, target_line, variable)
  controller_writes_target_for_variable?(controller_line, target_line, variable) &&
  $follows.select {|fol| fol[:line] == controller_line}.any? do |fol|
    path_exists_without_write?(fol[:pnext], target_line, variable)
  end
end

def controller_writes_target_for_variable?(controller_line, target_line, variable)
  $writes.any? {|w| w[:line] == controller_line && w[:name] == variable} &&
  $reads.any? {|w| w[:line] == target_line && w[:name] == variable}
end

def path_exists_without_write?(start_line, end_line, variable)
  if start_line == end_line
    true
  else
    $follows.select {|fol| fol[:line] == start_line}.any? do |fol|
      if $writes.any? {|w| w[:line] == start_line && w[:name] == variable}
        false
      elsif fol[:pnext] != end_line
        path_exists_without_write?(fol[:pnext], end_line, variable)
      else
        true
      end
    end
  end
end

def control_dep?(controller_line, target_line)
  $controls.any? {|con| con[:controller] == controller_line && con[:target] == target_line}
end

def parse_values_from_spec(spec)
  result = {}
  s = StringScanner.new(spec)
  while !s.eos?
    type = s.scan(/[lwrcfs]/)
    s.skip(/:/)
    content = ""
    while !s.eos? && !s.match?(/\|[lwrcfs]:/)
      content << s.getch
    end
    s.skip(/\|/) unless s.eos?

    case type
    when 'l'
      result[:line] = content.to_i
    when 'w'
      result[:write] = content
    when 'r'
      result[:read] = content
    when 'c'
      content = eval("[#{content}]").map {|elem| Range === elem ? elem.map {|n| n} : elem}.flatten
      result[:control] = content
    when 'f'
      content = eval("[#{content}]").map {|elem| Range === elem ? elem.map {|n| n} : elem}.flatten
      result[:follow] = content
    when 's'
      result[:source] = content
    end
  end

  result
end

def set_values_from_spec(spec)
  values = parse_values_from_spec(spec)
  if values[:line]
    $current_line = values[:line]
  end
  write($current_line, values[:write]) if values[:write]
  read($current_line, values[:read]) if values[:read]
  if values[:control]
    values[:control].each {|c| control($current_line, c)}
  end
  if values[:follow]
    values[:follow].each {|f| follow($current_line, f)}
  end
  source($current_line, values[:source]) if values[:source]

  $current_line += 1
end

def value_goes_to(line, var)
end

def value_comes_from(line, var)
end

if __FILE__ == $0
  # run like: ruby deps.rb -- --test
  if ARGV[1] == "--test"
    require 'test/unit'

    class TestDeps < Test::Unit::TestCase
      def test_with_irrelevant_line
        set_values_from_spec "l:0|f:1|c:1..4"
        set_values_from_spec "s:input x|w:x|f:2"
        set_values_from_spec "s:y = 0|w:y|f:3"
        set_values_from_spec "s:x = y|w:x|r:y|f:4"
        set_values_from_spec "s:print \"x = \" + x|r:x|f:5"

        assert !data_dep?(1, 4)
        assert data_dep?(3, 4)
      end
    end
  end
end
