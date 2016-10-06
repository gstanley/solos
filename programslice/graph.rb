class Graph
  attr_accessor :name, :graph

  def initialize(name = '')
    @name = name
    @graph = {} # make sure this is ordered
  end

  def repr
    "<%s %s [%s]>" % [self.class, name, graph.map {|key, value| "(#{key.repr}, #{value})"}.join(", ")]
  end

  def add(edge)
    # Adds a new edge with the given parameters to the graph.
    graph[edge] ||= []
    edge
  end

  def edges
    graph.keys
  end

  def connect(e1, e2)
    #assert isinstance(e1, type(e1)) and isinstance(e2, type(e2))
    edges = graph[e1] ||= []
    if !edges.include?(e2)
      graph[e1] << e2
    end
    add(e2)
  end

  def len
    graph.size
  end

  def [](key)
    graph[key]
  end
end

class Edge
  # Representing the edge of a :class:`graph`.
  attr_accessor :name, :lineno, :column

  def initialize(name, ln, column)
    @name = name
    @lineno = ln
    @column = column
  end

  def ==(other)
    self.class == other.class && state == other.state
  end

  def hash
    state.hash
  end

  def repr
    "<#{self.class} #{name} at ##{self.lineno}@#{column}>"
  end

  def self.create_from_astnode(node)
    Edge.new(node.id, node.lineno, node.col_offset)
  end

  protected
  def state
    [@name, @lineno, @column]
  end
end
