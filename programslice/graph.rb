class Graph
  attr_accessor :graph

  def initialize(name = '')
    @name = name
    @graph = {} # make sure this is ordered
  end

  def add(edge)
    # Adds a new edge with the given parameters to the graph.
    graph.set_default(edge, [])
    edge
  end
end

class Edge
  def initialize(name, ln, column)
  end
end
