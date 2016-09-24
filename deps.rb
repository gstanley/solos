$writes = []
$reads = []
$controls = []
$follows = []
$lines = []

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

def control_dep?(controller_line, target_line)
  $controls.select {|con| con[:target] == target_line}.map {|con| con[:controller]}.drop_while {|con| con == controller_line}.empty? &&
  $controls.any? {|con| con[:controller] == controller_line && con[:target] == target_line}
end

# parse spec
