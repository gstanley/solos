# ~ - point (taken from emacs) matches in between elements 
def xform(source, script)
  result = []
  source_enum = source.each
  script_enum = script.each
  hold_script_elem = false
  script_elem = nil
  loop do
    unless hold_script_elem
      script_elem = script_enum.next rescue :done
    end
    matcher, value = if script_elem != :done
                       script_elem.split('/')
                     else
                       [nil, nil]
                     end
    if matcher && matcher.length > 1 && matcher[0] == "\\"
      matcher = matcher[1..-1]
    end
    if value && value.length > 1 && value[0] == "\\"
      value = value[1..-1]
      value_escaped = true
    else
      value_escaped = false
    end
    if matcher != '~'
      source_elem = source_enum.next rescue :done
    end
    break if source_elem == :done && script_elem == :done
    hold_script_elem = false
    if script_elem != :done
      if matcher == source_elem || matcher == '~' || matcher == '.'
        if value
          result << (value == '.' && !value_escaped ? source_elem : value)
        end
      elsif source_elem != :done
        result << source_elem
        hold_script_elem = true
      end
    elsif source_elem != :done
      result << source_elem
    end
  end

  result
end
