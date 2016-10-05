class Graph
  attr_accessor :graph

  def initialize(name = '')
    @name = name
    @graph = {} # make sure this is ordered
  end

  def add(edge)
    # Adds a new edge with the given parameters to the graph.
    graph[edge] ||= []
    edge
  end

  def connect(e1, e2)
    #assert isinstance(e1, type(e1)) and isinstance(e2, type(e2))
    edges = graph[e1] ||= []
    if !edges.include?(e2)
      graph[e1] << e2
    end
    add(e2)
  end

  def [](key)
    graph[key]
  end
end

class Edge
  # Representing the edge of a :class:`graph`.
  def initialize(name, ln, column)
    @name = name
    @ln = ln
    @column = column
  end

  def ==(other)
    self.class == other.class && state == other.state
  end

  def hash
    state.hash
  end

  protected
  def state
    [@name, @ln, @column]
  end
end
