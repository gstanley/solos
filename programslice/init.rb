def get_formatter_klass(name)
  # Returns the slice result formatter given by it's name.
  if name.start_with?('line')
    LineFormatter
  elsif name.start_with?('text')
    TextOutputFormatter
  else
    VimOutPutFormatter
  end
end
