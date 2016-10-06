$dyn_slice = {}
$line_last_written = {}
$beat = 0

def line(ln, source, write = nil, read = nil)
  $beat += 0
  write.each do |wvar|
    $line_last_written[wvar] = ln
    $dyn_slice[wvar] ||= []
    slice = []
    read.each do |rvar|
      slice += $dyn_slice[rvar]
      slice += $line_last_written[rvar]
    end
    $dyn_slice[wvar] = slice
  end
end

def add_slice(beat, var)
end

def slice_at(beat)
  []
end

if __FILE__ == $0
  # run like: ruby dyn-slice.rb -- --test
  if ARGV[1] == "--test"
    require 'test/unit'

    class TestDeps < Test::Unit::TestCase
      def test_example_0
        assert_equal [], slice(0)
      end

      def test_example_1
        line 1, "n = read()", "n"
        assert_equal [], slice(1)
      end

      def test_example_2
        line 1, "n = read()", "n"
        line 2, "a = read()", "a"
        assert_equal [], slice(2)
      end

      def test_example_3
        line 1, "n = read()", "n"
        line 2, "a = read()", "a"
        line 3, "x = 1", "x"
        assert_equal [], slice(3)
      end

      def test_example_4
        line 1, "n = read()", "n"
        line 2, "a = read()", "a"
        line 3, "x = 1", "x"
        line 4, "b = a + x", "b", ["a", "x"]
        assert_equal [2, 3], slice(4)
      end
    end
  end
end
