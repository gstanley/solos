require 'test/unit'
#require './init'
require './graph'

class TestGraph < Test::Unit::TestCase
  def test_connect
    # This test assures that a connection is being made from Edge 1 to 2.
    graph = Graph.new('')
    e1 = graph.add(Edge.new('', 1, 1))
    e2 = graph.add(Edge.new('', 2, 1))
    graph.connect(e1, e2)
    assert_equal [], graph[e2]
    assert_equal [e2], graph[e1]
  end
end
