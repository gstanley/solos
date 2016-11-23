require "erb"

module Exemplar
  def Exemplar.hello_gen
    "\"hello...\""
  end

  def Exemplar.hello_exec
    code = "\"hello...\""

    {
      "<res>" => eval(code)
    }
  end

  def Exemplar.hello_gen_erb
    code = "<%= \"hello...\" %>"

    b = binding
    ERB.new(code).result(b)
  end
end
