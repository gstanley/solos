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

  def test_can_t_connect_twice
    # This test assures that edges which already have been connected will
    # not result in an additional edge again.
    graph = Graph.new('')
    e1 = Edge.new('', 1, 1)
    e2 = Edge.new('', 1, 2)
    5.times do
      graph.connect(e1, e2)
    end

    assert_equal [e2], graph[e1]
  end

  def test_edge_identity
    # Edges created with the same parameters are identical.
    e1 = Edge.new('n', 3, 4)
    e2 = Edge.new('n', 2, 6)
    assert_equal e1, e1
    assert !(e1 != e1)
    assert !(e1 != Edge.new('n', 3, 4))
    assert_not_equal e1, e2
  end
end
