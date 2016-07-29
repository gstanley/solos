# comprehensive suite of unit tests
# show as many forms of unit tests as I find
#   - maybe also integration and other kinds of tests

require "test/unit"

class TestExamples < Test::Unit::TestCase
  test "expression" do
    assert_equal 2, 1 + 1
  end

  test "method call" do
    assert_equal 0, Math.sin(0)
  end
end
