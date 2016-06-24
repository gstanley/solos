class MDate
  # load
  #   original object
  #   structure
  #   wrapped object
  def self.load(*args)
    
  end

  def method_missing(*args, &block)
  end

  def to_structure
  end
end

$x = nil
class GlobalXVar
  def getx
    $x
  end

  def setx(new_x)
    $x = new_x
    nil
  end
end

class MGlobalVar
  def self.load(*args)
  end

  def self.load_ident(obj)
    obj
  end

  def method_missing(*args, &block)
  end

  def to_structure
  end
end

# debugger utilities
# - get new wrapped object
# - undo on wrapped object
# -   and original object?
