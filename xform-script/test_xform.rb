require 'test/unit'
require 'pry'
require './xform'

class TestXForm < Test::Unit::TestCase
  test "empty script and empty source results in empty" do
    assert_equal [], xform([], [])
  end

  test "empty script results in input source" do
    assert_equal ['a'], xform(['a'], [])
  end

  test "point match with empty script" do
    assert_equal ['a'], xform([], ["~/a"])
  end

  test "match a and replace with itself" do
    assert_equal ['a'], xform(['a'], ["a/a"])
  end

  test "fail to match a results in original source" do
    assert_equal ['b'], xform(['b'], ["a/a"])
  end

  test "match a and replace the element" do
    assert_equal ['b'], xform(['a'], ["a/b"])
  end

  test "match anything and replace the element" do
    assert_equal ['b'], xform(['a'], ["./b"])
  end

  test "match a and remove it" do
    assert_equal [], xform(['a'], ["a/"])
  end

  test "delete a from empty source" do
    assert_equal [], xform([], ["a/"])
  end

  test "add element to list" do
    assert_equal ['a', 'b'], xform(['a'], ["a/a", "~/b"])
  end

  test "add element to beginning of list" do
    assert_equal ['b', 'a'], xform(['a'], ["~/b", "a/a"])
  end

  test "add element to beginning of list with transfer of excess source" do
    assert_equal ['b', 'a'], xform(['a'], ["~/b"])
  end

  test "replace element in middle of list" do
    assert_equal ['a', 'x', 'c'], xform(['a', 'b', 'c'], ["b/x"])
  end

  test "insert element in middle of list" do
    assert_equal ['a', 'x', 'c'], xform(['a', 'c'], ["a/a", "~/x"])
  end

  test "replace with match" do
    assert_equal ['a'], xform(['a'], ["./."])
  end

  test "replace with escaped ." do
    binding.pry
    assert_equal ['.'], xform(['a'], ["./\\."])
  end

  test "replace with escaped \\" do
    assert_equal ["\\"], xform(['a'], ["./\\"])
  end
end
