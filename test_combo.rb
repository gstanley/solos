def test_combo(params, prefix = [])
  if params.empty?
    if prefix.empty?
      []
    else
      [prefix]
    end
  else
    result = []
    first = params.keys.first
    values = params[first]
    rest = params.dup
    rest.delete(first)
    values.each do |value|
#      result += test_combo(rest, "#{prefix}#{prefix.empty? ? "" : ";"}#{first}=#{value.to_s}")
      result += test_combo(rest, prefix + [[first, value]])
    end
    result
  end
end
