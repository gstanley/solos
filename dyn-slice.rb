require 'byebug'
$dyn_slice = {}
$line_last_written = {}
$beat = 0
$slices = {}

def line(ln, source, write = nil, read = nil)
  $beat += 1
  $slices[$beat] = []
  [*write].each do |wvar|
    $dyn_slice[wvar] ||= []
    slice = []
    [*read].each do |rvar|
      slice += $dyn_slice[rvar] if $dyn_slice[rvar]
      slice << $line_last_written[rvar] if $line_last_written[rvar]
    end
    slice.uniq!
    $dyn_slice[wvar] = slice
    $slices[$beat] = ($slices[$beat] + slice).uniq
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

      def test_example
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
        assert_equal [], slice_at(1)
        assert_equal [], slice_at(2)
        assert_equal [], slice_at(3)
        assert_equal [2, 3], slice_at(4).sort
        assert_equal [2], slice_at(5)
        assert_equal [], slice_at(6)
        assert_equal [], slice_at(7)
        assert_equal [1, 6], slice_at(8).sort
        assert_equal [1, 2, 3, 4, 6, 8], slice_at(9).sort
        assert_equal [1, 2, 3, 4, 5, 6, 8, 9], slice_at(10).sort
        assert_equal [1, 3, 6, 7, 8], slice_at(11).sort
        assert_equal [1, 6, 8], slice_at(12).sort
        assert_equal [1, 6, 8, 13], slice_at(13).sort
        assert_equal [1, 2, 3, 4, 6, 8, 13], slice_at(14).sort
        assert_equal [1, 2, 3, 4, 5, 6, 8, 9, 13], slice_at(15).sort
        assert_equal [1, 3, 6, 7, 8, 12, 13], slice_at(16).sort
        assert_equal [1, 6, 8, 13], slice_at(17).sort
        assert_equal [1, 6, 8, 13], slice_at(18).sort
        assert_equal [1, 3, 6, 7, 8, 12, 13], slice_at(19).sort
      end

      def test_fib_function
        line 21, "int n = 9;", "main/n"
        line 23, "while n > 0", "main/p22", "main/n" # n: 9
        line 25, "printf(\"fib(%d)=%dN\", n, fib(n));", ["main/c25", "main/o25"], ["main/n", "main/p22"]
        line 5, "int fib(int n)", ["fib/e5", "fib/n"], ["main/c25", "main/n"]
        line 7, "int f, f0 = 1, f1 = 1;", ["fib/f", "fib/f0", "fib/f1"], "fib/e5"
        line 9, "while (n > 1) {", "fib/p9", ["fib/n", "fib/e5"] # n: 9
        line 10, "n = n - 1;", "fib/n", ["fib/n", "fib/p9"]
        line 11, "f = f0 + f1;", "fib/f", ["fib/f0", "fib/f1", "fib/p9"]
        line 12, "f0 = f1;", "fib/f0", ["fib/f1", "fib/p9"]
        line 13, "f1 = f;", "fib/f1", ["fib/f", "fib/p9"]
        line 9, "while (n > 1) {", "fib/p9", ["fib/n", "fib/e5"] # n: 8
        line 10, "n = n - 1;", "fib/n", ["fib/n", "fib/p9"]
        line 11, "f = f0 + f1;", "fib/f", ["fib/f0", "fib/f1", "fib/p9"]
        line 12, "f0 = f1;", "fib/f0", ["fib/f1", "fib/p9"]
        line 13, "f1 = f;", "fib/f1", ["fib/f", "fib/p9"]
        line 9, "while (n > 1) {", "fib/p9", ["fib/n", "fib/e5"] # n: 7
        line 10, "n = n - 1;", "fib/n", ["fib/n", "fib/p9"]
        line 11, "f = f0 + f1;", "fib/f", ["fib/f0", "fib/f1", "fib/p9"]
        line 12, "f0 = f1;", "fib/f0", ["fib/f1", "fib/p9"]
        line 13, "f1 = f;", "fib/f1", ["fib/f", "fib/p9"]
        line 9, "while (n > 1) {", "fib/p9", ["fib/n", "fib/e5"] # n: 6
        line 10, "n = n - 1;", "fib/n", ["fib/n", "fib/p9"]
        line 11, "f = f0 + f1;", "fib/f", ["fib/f0", "fib/f1", "fib/p9"]
        line 12, "f0 = f1;", "fib/f0", ["fib/f1", "fib/p9"]
        line 13, "f1 = f;", "fib/f1", ["fib/f", "fib/p9"]
        line 9, "while (n > 1) {", "fib/p9", ["fib/n", "fib/e5"] # n: 5
        line 10, "n = n - 1;", "fib/n", ["fib/n", "fib/p9"]
        line 11, "f = f0 + f1;", "fib/f", ["fib/f0", "fib/f1", "fib/p9"]
        line 12, "f0 = f1;", "fib/f0", ["fib/f1", "fib/p9"]
        line 13, "f1 = f;", "fib/f1", ["fib/f", "fib/p9"]
        line 9, "while (n > 1) {", "fib/p9", ["fib/n", "fib/e5"] # n: 4
        line 10, "n = n - 1;", "fib/n", ["fib/n", "fib/p9"]
        line 11, "f = f0 + f1;", "fib/f", ["fib/f0", "fib/f1", "fib/p9"]
        line 12, "f0 = f1;", "fib/f0", ["fib/f1", "fib/p9"]
        line 13, "f1 = f;", "fib/f1", ["fib/f", "fib/p9"]
        line 9, "while (n > 1) {", "fib/p9", ["fib/n", "fib/e5"] # n: 3
        line 10, "n = n - 1;", "fib/n", ["fib/n", "fib/p9"]
        line 11, "f = f0 + f1;", "fib/f", ["fib/f0", "fib/f1", "fib/p9"]
        line 12, "f0 = f1;", "fib/f0", ["fib/f1", "fib/p9"]
        line 13, "f1 = f;", "fib/f1", ["fib/f", "fib/p9"]
        line 9, "while (n > 1) {", "fib/p9", ["fib/n", "fib/e5"] # n: 2
        line 10, "n = n - 1;", "fib/n", ["fib/n", "fib/p9"]
        line 11, "f = f0 + f1;", "fib/f", ["fib/f0", "fib/f1", "fib/p9"]
        line 12, "f0 = f1;", "fib/f0", ["fib/f1", "fib/p9"]
        line 13, "f1 = f;", "fib/f1", ["fib/f", "fib/p9"]
        line 9, "while (n > 1) {", "fib/p9", ["fib/n", "fib/e5"] # n: 1
        line 16, "return f;", "<none>", ["fib/f", "fib/e5"]
        assert_equal [], slice_at(1)
        assert_equal [21], slice_at(2)
        assert_equal [21, 23], slice_at(3).sort
        assert_equal [21, 23, 25], slice_at(4).sort
        assert_equal [5, 21, 23, 25], slice_at(5).sort
        assert_equal [5, 21, 23, 25], slice_at(6).sort
        assert_equal [5, 9, 21, 23, 25], slice_at(7).sort
        assert_equal [5, 7, 9, 21, 23, 25], slice_at(8).sort
        assert_equal [5, 7, 9, 21, 23, 25], slice_at(9).sort
        assert_equal [5, 7, 9, 11, 21, 23, 25], slice_at(10).sort
        assert_equal [5, 9, 10, 21, 23, 25], slice_at(11).sort
        assert_equal [5, 9, 10, 21, 23, 25], slice_at(12).sort
        assert_equal [5, 7, 9, 10, 11, 12, 13, 21, 23, 25], slice_at(13).sort
        assert_equal [5, 7, 9, 10, 11, 13, 21, 23, 25], slice_at(14).sort
        assert_equal [5, 7, 9, 10, 11, 12, 13, 21, 23, 25], slice_at(15).sort
        assert_equal [5, 9, 10, 21, 23, 25], slice_at(16).sort
        assert_equal [5, 9, 10, 21, 23, 25], slice_at(17).sort
        assert_equal [5, 7, 9, 10, 11, 12, 13, 21, 23, 25], slice_at(18).sort
        assert_equal [5, 7, 9, 10, 11, 12, 13, 21, 23, 25], slice_at(19).sort
        assert_equal [5, 7, 9, 10, 11, 12, 13, 21, 23, 25], slice_at(20).sort
        assert_equal [5, 9, 10, 21, 23, 25], slice_at(21).sort
        assert_equal [5, 9, 10, 21, 23, 25], slice_at(22).sort
        assert_equal [5, 7, 9, 10, 11, 12, 13, 21, 23, 25], slice_at(23).sort
        assert_equal [5, 7, 9, 10, 11, 12, 13, 21, 23, 25], slice_at(24).sort
        assert_equal [5, 7, 9, 10, 11, 12, 13, 21, 23, 25], slice_at(25).sort
        assert_equal [5, 9, 10, 21, 23, 25], slice_at(26).sort
        assert_equal [5, 9, 10, 21, 23, 25], slice_at(27).sort
        assert_equal [5, 7, 9, 10, 11, 12, 13, 21, 23, 25], slice_at(28).sort
        assert_equal [5, 7, 9, 10, 11, 12, 13, 21, 23, 25], slice_at(29).sort
        assert_equal [5, 7, 9, 10, 11, 12, 13, 21, 23, 25], slice_at(30).sort
        assert_equal [5, 9, 10, 21, 23, 25], slice_at(31).sort
        assert_equal [5, 9, 10, 21, 23, 25], slice_at(32).sort
        assert_equal [5, 7, 9, 10, 11, 12, 13, 21, 23, 25], slice_at(33).sort
        assert_equal [5, 7, 9, 10, 11, 12, 13, 21, 23, 25], slice_at(34).sort
        assert_equal [5, 7, 9, 10, 11, 12, 13, 21, 23, 25], slice_at(35).sort
        assert_equal [5, 9, 10, 21, 23, 25], slice_at(36).sort
        assert_equal [5, 9, 10, 21, 23, 25], slice_at(37).sort
        assert_equal [5, 7, 9, 10, 11, 12, 13, 21, 23, 25], slice_at(38).sort
        assert_equal [5, 7, 9, 10, 11, 12, 13, 21, 23, 25], slice_at(39).sort
        assert_equal [5, 7, 9, 10, 11, 12, 13, 21, 23, 25], slice_at(40).sort
        assert_equal [5, 9, 10, 21, 23, 25], slice_at(41).sort
        assert_equal [5, 9, 10, 21, 23, 25], slice_at(42).sort
        assert_equal [5, 7, 9, 10, 11, 12, 13, 21, 23, 25], slice_at(43).sort
        assert_equal [5, 7, 9, 10, 11, 12, 13, 21, 23, 25], slice_at(44).sort
        assert_equal [5, 7, 9, 10, 11, 12, 13, 21, 23, 25], slice_at(45).sort
        assert_equal [5, 9, 10, 21, 23, 25], slice_at(46).sort
        assert_equal [5, 7, 9, 10, 11, 12, 13, 21, 23, 25], slice_at(47).sort
      end
    end
  end
end
