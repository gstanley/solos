require 'byebug'
$dyn_slice = {}
$line_last_written = {}
$beat = 0
$slices = {}

def line(ln, source, write = nil, read = nil)
  $beat += 1
  [*write].each do |wvar|
    $dyn_slice[wvar] ||= []
    slice = []
    [*read].each do |rvar|
      slice += $dyn_slice[rvar]
      slice << $line_last_written[rvar]
    end
    slice.uniq!
    $dyn_slice[wvar] = slice
    $slices[$beat] = slice
    $line_last_written[wvar] = ln
  end
end

def add_slice(beat, var)
end

def slice_at(beat)
  $slices[beat]
end

if __FILE__ == $0
  # run like: ruby dyn-slice.rb -- --test
  if ARGV[1] == "--test"
    require 'test/unit'

    class TestDeps < Test::Unit::TestCase
      def setup
        $dyn_slice = {}
        $line_last_written = {}
        $beat = 0
      end

      def test_example_1
        line 1, "n = read()", "n"
        assert_equal [], slice_at(1)
      end

      def test_example_2
        line 1, "n = read()", "n"
        line 2, "a = read()", "a"
        assert_equal [], slice_at(2)
      end

      def test_example_3
        line 1, "n = read()", "n"
        line 2, "a = read()", "a"
        line 3, "x = 1", "x"
        assert_equal [], slice_at(3)
      end

      def test_example_4
        line 1, "n = read()", "n"
        line 2, "a = read()", "a"
        line 3, "x = 1", "x"
        line 4, "b = a + x", "b", ["a", "x"]
        assert_equal [2, 3], slice_at(4).sort
      end

      def test_example_5
        line 1, "n = read()", "n"
        line 2, "a = read()", "a"
        line 3, "x = 1", "x"
        line 4, "b = a + x", "b", ["a", "x"]
        line 5, "a = a + 1", "a", "a"
        assert_equal [2], slice_at(5)
      end

      def test_example_6
        line 1, "n = read()", "n"
        line 2, "a = read()", "a"
        line 3, "x = 1", "x"
        line 4, "b = a + x", "b", ["a", "x"]
        line 5, "a = a + 1", "a", "a"
        line 6, "i = 1", "i"
        assert_equal [], slice_at(6)
      end

      def test_example_7
        line 1, "n = read()", "n"
        line 2, "a = read()", "a"
        line 3, "x = 1", "x"
        line 4, "b = a + x", "b", ["a", "x"]
        line 5, "a = a + 1", "a", "a"
        line 6, "i = 1", "i"
        line 7, "s = 0", "s"
        assert_equal [], slice_at(7)
      end

      def test_example_8
        line 1, "n = read()", "n"
        line 2, "a = read()", "a"
        line 3, "x = 1", "x"
        line 4, "b = a + x", "b", ["a", "x"]
        line 5, "a = a + 1", "a", "a"
        line 6, "i = 1", "i"
        line 7, "s = 0", "s"
        line 8, "while (i <= n) {", "p8", ["i", "n"]
        assert_equal [1, 6], slice_at(8).sort
      end

      def test_example_9
        line 1, "n = read()", "n"
        line 2, "a = read()", "a"
        line 3, "x = 1", "x"
        line 4, "b = a + x", "b", ["a", "x"]
        line 5, "a = a + 1", "a", "a"
        line 6, "i = 1", "i"
        line 7, "s = 0", "s"
        line 8, "while (i <= n) {", "p8", ["i", "n"]
        line 9, "if (b > 0)", "p9", ["b", "p8"]
        assert_equal [1, 2, 3, 4, 6, 8], slice_at(9).sort
      end

      def test_example_10
        line 1, "n = read()", "n"
        line 2, "a = read()", "a"
        line 3, "x = 1", "x"
        line 4, "b = a + x", "b", ["a", "x"]
        line 5, "a = a + 1", "a", "a"
        line 6, "i = 1", "i"
        line 7, "s = 0", "s"
        line 8, "while (i <= n) {", "p8", ["i", "n"]
        line 9, "if (b > 0)", "p9", ["b", "p8"]
        line 10, "if (a > 1)", "p10", ["a", "p9"]
        assert_equal [1, 2, 3, 4, 5, 6, 8, 9], slice_at(10).sort
      end

      def test_example_11
        line 1, "n = read()", "n"
        line 2, "a = read()", "a"
        line 3, "x = 1", "x"
        line 4, "b = a + x", "b", ["a", "x"]
        line 5, "a = a + 1", "a", "a"
        line 6, "i = 1", "i"
        line 7, "s = 0", "s"
        line 8, "while (i <= n) {", "p8", ["i", "n"]
        line 9, "if (b > 0)", "p9", ["b", "p8"]
        line 10, "if (a > 1)", "p10", ["a", "p9"]
        line 12, "s = s + x", "s", ["s", "x", "p8"]
        assert_equal [1, 3, 6, 7, 8], slice_at(11).sort
      end

      def test_example_12
        line 1, "n = read()", "n"
        line 2, "a = read()", "a"
        line 3, "x = 1", "x"
        line 4, "b = a + x", "b", ["a", "x"]
        line 5, "a = a + 1", "a", "a"
        line 6, "i = 1", "i"
        line 7, "s = 0", "s"
        line 8, "while (i <= n) {", "p8", ["i", "n"]
        line 9, "if (b > 0)", "p9", ["b", "p8"]
        line 10, "if (a > 1)", "p10", ["a", "p9"]
        line 12, "s = s + x", "s", ["s", "x", "p8"]
        line 13, "i = i + 1", "i", ["i", "p8"]
        assert_equal [1, 6, 8], slice_at(12).sort
      end

      def test_example_13
        line 1, "n = read()", "n"
        line 2, "a = read()", "a"
        line 3, "x = 1", "x"
        line 4, "b = a + x", "b", ["a", "x"]
        line 5, "a = a + 1", "a", "a"
        line 6, "i = 1", "i"
        line 7, "s = 0", "s"
        line 8, "while (i <= n) {", "p8", ["i", "n"]
        line 9, "if (b > 0)", "p9", ["b", "p8"]
        line 10, "if (a > 1)", "p10", ["a", "p9"]
        line 12, "s = s + x", "s", ["s", "x", "p8"]
        line 13, "i = i + 1", "i", ["i", "p8"]
        line 8, "while (i <= n) {", "p8", ["i", "n"]
        assert_equal [1, 6, 8, 13], slice_at(13).sort
      end

      def test_example_14
        line 1, "n = read()", "n"
        line 2, "a = read()", "a"
        line 3, "x = 1", "x"
        line 4, "b = a + x", "b", ["a", "x"]
        line 5, "a = a + 1", "a", "a"
        line 6, "i = 1", "i"
        line 7, "s = 0", "s"
        line 8, "while (i <= n) {", "p8", ["i", "n"]
        line 9, "if (b > 0)", "p9", ["b", "p8"]
        line 10, "if (a > 1)", "p10", ["a", "p9"]
        line 12, "s = s + x", "s", ["s", "x", "p8"]
        line 13, "i = i + 1", "i", ["i", "p8"]
        line 8, "while (i <= n) {", "p8", ["i", "n"]
        line 9, "if (b > 0)", "p9", ["b", "p8"]
        assert_equal [1, 2, 3, 4, 6, 8, 13], slice_at(14).sort
      end

      def test_example_15
        line 1, "n = read()", "n"
        line 2, "a = read()", "a"
        line 3, "x = 1", "x"
        line 4, "b = a + x", "b", ["a", "x"]
        line 5, "a = a + 1", "a", "a"
        line 6, "i = 1", "i"
        line 7, "s = 0", "s"
        line 8, "while (i <= n) {", "p8", ["i", "n"]
        line 9, "if (b > 0)", "p9", ["b", "p8"]
        line 10, "if (a > 1)", "p10", ["a", "p9"]
        line 12, "s = s + x", "s", ["s", "x", "p8"]
        line 13, "i = i + 1", "i", ["i", "p8"]
        line 8, "while (i <= n) {", "p8", ["i", "n"]
        line 9, "if (b > 0)", "p9", ["b", "p8"]
        line 10, "if (a > 1)", "p10", ["a", "p9"]
        assert_equal [1, 2, 3, 4, 5, 6, 8, 9, 13], slice_at(15).sort
      end

      def test_example_16
        line 1, "n = read()", "n"
        line 2, "a = read()", "a"
        line 3, "x = 1", "x"
        line 4, "b = a + x", "b", ["a", "x"]
        line 5, "a = a + 1", "a", "a"
        line 6, "i = 1", "i"
        line 7, "s = 0", "s"
        line 8, "while (i <= n) {", "p8", ["i", "n"]
        line 9, "if (b > 0)", "p9", ["b", "p8"]
        line 10, "if (a > 1)", "p10", ["a", "p9"]
        line 12, "s = s + x", "s", ["s", "x", "p8"]
        line 13, "i = i + 1", "i", ["i", "p8"]
        line 8, "while (i <= n) {", "p8", ["i", "n"]
        line 9, "if (b > 0)", "p9", ["b", "p8"]
        line 10, "if (a > 1)", "p10", ["a", "p9"]
        line 12, "s = s + x", "s", ["s", "x", "p8"]
        assert_equal [1, 3, 6, 7, 8, 12, 13], slice_at(16).sort
      end

      def test_example_17
        line 1, "n = read()", "n"
        line 2, "a = read()", "a"
        line 3, "x = 1", "x"
        line 4, "b = a + x", "b", ["a", "x"]
        line 5, "a = a + 1", "a", "a"
        line 6, "i = 1", "i"
        line 7, "s = 0", "s"
        line 8, "while (i <= n) {", "p8", ["i", "n"]
        line 9, "if (b > 0)", "p9", ["b", "p8"]
        line 10, "if (a > 1)", "p10", ["a", "p9"]
        line 12, "s = s + x", "s", ["s", "x", "p8"]
        line 13, "i = i + 1", "i", ["i", "p8"]
        line 8, "while (i <= n) {", "p8", ["i", "n"]
        line 9, "if (b > 0)", "p9", ["b", "p8"]
        line 10, "if (a > 1)", "p10", ["a", "p9"]
        line 12, "s = s + x", "s", ["s", "x", "p8"]
        line 13, "i = i + 1", "i", ["i", "p8"]
        assert_equal [1, 6, 8, 13], slice_at(17).sort
      end

      def test_example_18
        line 1, "n = read()", "n"
        line 2, "a = read()", "a"
        line 3, "x = 1", "x"
        line 4, "b = a + x", "b", ["a", "x"]
        line 5, "a = a + 1", "a", "a"
        line 6, "i = 1", "i"
        line 7, "s = 0", "s"
        line 8, "while (i <= n) {", "p8", ["i", "n"]
        line 9, "if (b > 0)", "p9", ["b", "p8"]
        line 10, "if (a > 1)", "p10", ["a", "p9"]
        line 12, "s = s + x", "s", ["s", "x", "p8"]
        line 13, "i = i + 1", "i", ["i", "p8"]
        line 8, "while (i <= n) {", "p8", ["i", "n"]
        line 9, "if (b > 0)", "p9", ["b", "p8"]
        line 10, "if (a > 1)", "p10", ["a", "p9"]
        line 12, "s = s + x", "s", ["s", "x", "p8"]
        line 13, "i = i + 1", "i", ["i", "p8"]
        line 8, "while (i <= n) {", "p8", ["i", "n"]
        assert_equal [1, 6, 8, 13], slice_at(18).sort
      end

      def test_example_19
        line 1, "n = read()", "n"
        line 2, "a = read()", "a"
        line 3, "x = 1", "x"
        line 4, "b = a + x", "b", ["a", "x"]
        line 5, "a = a + 1", "a", "a"
        line 6, "i = 1", "i"
        line 7, "s = 0", "s"
        line 8, "while (i <= n) {", "p8", ["i", "n"]
        line 9, "if (b > 0)", "p9", ["b", "p8"]
        line 10, "if (a > 1)", "p10", ["a", "p9"]
        line 12, "s = s + x", "s", ["s", "x", "p8"]
        line 13, "i = i + 1", "i", ["i", "p8"]
        line 8, "while (i <= n) {", "p8", ["i", "n"]
        line 9, "if (b > 0)", "p9", ["b", "p8"]
        line 10, "if (a > 1)", "p10", ["a", "p9"]
        line 12, "s = s + x", "s", ["s", "x", "p8"]
        line 13, "i = i + 1", "i", ["i", "p8"]
        line 8, "while (i <= n) {", "p8", ["i", "n"]
        line 15, "write(s)", "o15", "s"
        assert_equal [1, 3, 6, 7, 8, 12, 13], slice_at(19).sort
      end
    end
  end
end
