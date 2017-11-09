class Wrapper
  def initialize
    @prev_env = {}
    @trace = TracePoint.new do |tp|
      tp.binding.local_variables.each {|var| @prev_env[var] = tp.binding.local_variable_get(var)}
      @lines = File.readlines(tp.path)
      puts tp.event
      puts tp.lineno
      puts tp.path
      puts @lines[tp.lineno - 1]
      puts @prev_env
    end
  end
    
  def exec
    @trace.enable
    yield
    @trace.disable
  end
end
