require 'test/unit'
require './xform'

class TestXForm < Test::Unit::TestCase
  test "xform an empty script results in same" do
    assert_equal({a: 123}, xform({a: 123}, {}))
  end
end
