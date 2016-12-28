require "erb"

# hello_gen
"\"hello...\""

# hello_exec
code = "\"hello...\""

{
  "<res>" => eval(code)
}

# hello_gen_erb
code = "<%= \"hello...\" %>"

b = binding
ERB.new(code).result(b)

# ch 1
1.class
# doc => Fixnum: the number 1 is a Fixnum
# parse => s(:send, s(:int, 1), :class)
# <res> => Fixnum
0.0.class
true.class
false.class
nil.class
3.times {print "Ruby! "}
# doc => Prints "Ruby! Ruby! Ruby! "
# parse => s(:block,
#            s(:send, s(:int, 3), :times),
#            s(:args),
#            s(:send, nil, :print, s(:str, "Ruby! ")))
# <out> => Ruby! Ruby! Ruby! 
# <res> => 3
1.upto(9) {|x| print x}
a = [3, 2, 1]
a[3] = a[2] - 1
a.each do |elt|
  print elt + 1
end
a = [1, 2, 3, 4]
b = a.map {|x| x * x}
c = a.select {|x| x % 2 == 0}
a.inject do |sum, x|
  sum + x
end
h = {
  :one => 1,
  :two => 2
}
h[:one]
h[:three] = 3
h.each do |key, value|
  print "#{value}:#{key}; "
end
File.open("data.txt") do |f|
  line = f.readline
end
t = Thread.new do
  File.read("data.txt")
end
print "#{value}:#{key}; "
minimum = if x < y then x else y end
1 + 2
1 * 2
1 + 2 == 3
2 ** 1024
"Ruby" + " rocks!"
"Ruby! " * 3
"%d %s" % [3, "rubies"]
max = x > y ? x : y
def square(x)
  x * x
end
def Math.square(x)
  x * x
end
x = 1
x += 1
y -= 1
x, y = 1, 2
a, b = b, a
x, y, z = [1, 2, 3]
def polar(x, y)
  theta = Math.atan2(y, x)
  r = Math.hypot(x, y)
  [r, theta]
end
distance, angle = polar(2, 2)
o.x=(1)
o.x = 1
/[Rr]uby/
/\d{5}/
1..3
1...3
generation = case birthyear
  when 1946..1963: "Baby Boomer"
  when 1964..1976: "Generation X"
  when 1978..2000: "Generation Y"
  else nil
end
def are_you_sure?
  while true
    print "Are you sure? [y/n]: "
    response = gets
    case response
    when /^[yY]/
      return true
    when /^[nN]/, /^$/
      return false
    end
  end
end
class Sequence
  include Enumerable
  def initialize(from, to, by)
    @from, @to, @by = from, to, by
  end
  def each
    x = @from
    while x <= @to
      yield x
      x += @by
    end
  end
  def length
    return 0 if @from > @to
    Integer((@to - @from) / @by) + 1
  end
  alias size length
  def[](index)
    return nil if index < 0
    v = @from + index * @by
    if v <= @to
      v
    else
      nil
    end
  end
  def *(factor)
    Sequence.new(@from * factor, @to * factor, @by * factor)
  end
  def +(offset)
    Sequence.new(@from + offset, @to + offset, @by)
  end
end
s = Sequence.new(1, 10, 2)
s.each {|x| print x}
print s[s.size - 1]
t = (s + 1) * 2
module Sequences
  def self.fromtoby(from, to, by)
    x = from
    while x <= to
      yield x
      x += by
    end
  end
end
Sequences.fromtoby(1, 10, 2) {|x| print x}
class Range
  def by(step)
    x = self.begin
    if exclude_end?
      while x < self.end
        yield x
        x += step
      end
    else
      while x <= self.end
        yield x
        x += step
      end
    end
  end
end
(0..10).by(2) {|x| print x}
(0...10).by(2) {|x| print x}
% ruby -e 'puts "hello world!"'
% ruby hello.rb
9.downto(1) {|n| print n}
puts " blastoff!"
% ruby count.rb
$ irb --simple-prompt
>> 2**3
>> "Ruby! " * 3
>> 1.upto(3) {|x| puts x}
>> quit
ri Array
ri Array.sort
ri Hash#each
ri Math::sqrt
# gem install rails
gem list
gem enviroment
gem update rails
gem update
gem update --system
gem uninstall rails
require 'rubygems'
gem 'RedCloth', '> 2.0', '< 4.0'
require 'RedCloth'
module Sudoku
  class Puzzle
    ASCII = ".123456789"
    BIN = "\000\001\002\003\004\005\006\007\010\011"
    def initialize(lines)
      if (lines.respond_to? :join)
        s = lines.join
      else
        s = lines.dup
      end
      s.gsub!(/\s/, "")
      raise Invalid, "Grid is the wrong size" unless s.size == 81
      if i = s.index(/[^123456789\.]/)
        raise Invalid, "Illegal character #{s[i,1]} in puzzle"
      end
      s.tr!(ASCII, BIN)
      @grid = s.unpack('c*')
      raise Invalid, "Initial puzzle has duplicates" if has_duplicates?
    end
    def to_s
      (0..8).collect{|r| @grid[r * 9, 9].pack('c9')}.join("\n").tr(BIN, ASCII)
    end
    def dup
      copy = super
      @grid = @grid.dup
      copy
    end
    def [](row, col)
      @grid[row * 9 + col]
    end
    def []=(row, col, newvalue)
      unless (0..9).include? newvalue
        raise Invalid, "illegal cell value"
      end
      @grid[row * 9 + col] = newvalue
    end
    BoxOfIndex = [
      0, 0, 0, 1, 1, 1, 2, 2, 2, 0, 0, 0, 1, 1, 1, 2, 2, 2, 0, 0, 0, 1, 1, 1, 2, 2, 2,
      3, 3, 3, 4, 4, 4, 5, 5, 5, 3, 3, 3, 4, 4, 4, 5, 5, 5, 3, 3, 3, 4, 4, 4, 5, 5, 5,
      6, 6, 6, 7, 7, 7, 8, 8, 8, 6, 6, 6, 7, 7, 7, 8, 8, 8, 6, 6, 6, 7, 7, 7, 8, 8, 8
    ].freeze
    def each_unknown
      0.upto 8 do |row|
        0.upto 8 do |col|
          index = row * 9 + col
          next if @grid[index] != 0
          box = BoxOfIndex[index]
          yield row, col, box
        end
      end
    end
    def has_duplicates?
      0.upto(8) {|row| return true if rowdigits(row).uniq!}
      0.upto(8) {|col| return true if coldigits(col).uniq!}
      0.upto(8) {|box| return true if boxdigits(box).uniq!}
      false
    end
    AllDigits = [1, 2, 3, 4, 5, 6, 7, 8, 9].freeze
    def possible(row, col, box)
      AllDigits - (rowdigits(row) + coldigits(col) + boxdigits(box))
    end
    private
    def rowdigits(row)
      @grid[row * 9, 9] - [0]
    end
    def coldigits(col)
      result = []
      col.step(80, 9) {|i|
        v = @grid[i]
        result << v if (v != 0)
      }
      result
    end
    BoxToIndex = [0, 3, 6, 27, 30, 33, 54, 57, 60].freeze
    def boxdigits(b)
      i = BoxToIndex[b]
      [
        @grid[i], @grid[i + 1], @grid[i + 2],
        @grid[i+9], @grid[i + 10], @grid[i + 11],
        @grid[i+18], @grid[i + 19], @grid[i + 20]
      ] - [0]
    end
  end
  class Invalid < StandardError
  end
  class Impossible < StandardError
  end
  def Sudoku.scan(puzzle)
    unchanged = false
    until unchanged
      unchanged = true
      rmin, cmin, pmin = nil
      min = 10
      puzzle.each_unknown do |row, col, box|
        p = puzzle.possible(row, col, box)
        case p.size
        when 0
          raise Impossible
        when 1
          puzzle[row,col] = p[0]
          unchanged = false
        else
          if unchanged && p.size < min
            min = p.size
            rmin, cmin, pmin = row, col, p
          end
        end
      end
    end
    return rmin, cmin, pmin
  end
  def Sudoku.solve(puzzle)
    puzzle = puzzle.dup
    r,c,p = scan(puzzle)
    return puzzle if r == nil
    p.each do |guess|
      puzzle[r, c] = guess
      begin
        return solve(puzzle)
      rescue Impossible
        next
      end
    end
    raise Impossible
  end
end

value_string = {
  "code" => "\"hello...\"",
  "doc" => {
    "desc" => "string value",
    "kw" => [],
    "cat" => []
  },
  "parse-tree" => <<END
children:
- hello...
type: :str
END
}

def capture
  orig_stdout = $stdout.dup
  orig_stderr = $stderr.dup
  captured_stdout = StringIO.new
  captured_stderr = StringIO.new
  $stdout = captured_stdout
  $stderr = captured_stderr
  result = yield
  captured_stdout.rewind
  captured_stderr.rewind
  return captured_stdout.string, captured_stderr.string, result
ensure
  $stdout = orig_stdout
  $stderr = orig_stderr
end

def exec(__params)
  __code = __params["code"]
  __vars = __params["vars"]
  __deps = __params["deps"]
  __result = {}
  __b = binding
  [*__deps].each {|dep| eval(dep, __b)}
  __result["<out>"],
  __result["<err>"],
  __result["<res>"] = capture {eval(__code, __b)}
  [*__vars].each {|var| __result[var] = __b.eval(var)}

  __result
end

def desc(__params)
  __params["doc"]["desc"]
end

def keywords(__params)
  __params["doc"]["kw"]
end

def categories(__params)
  __params["doc"]["cat"]
end

def parse_tree(__params)
  YAML.load(__params["parse-tree"])
end

=begin
* ---
** outputs/effects
*** sensors
*** catch
** procedures
** logical constructs
- business logic
** data structures
- parsers for string data
** terms?
** first?: git log |grep stanley => files/procs changed
** dependencies
** call graph
*** entry points
* qd exec patterns
** doc
** generate
** exec expression
*** DONE no side effects/no dependencies
*** DONE sets variable
*** DONE dep on variable
*** DONE dep on proc (calls)
*** define proc (like sets variable but for proc name)
*** output (w/ sensor)
**** DONE console/stdout(,stderr)
**** file
**** socket
**** env variable
*** input
**** console/stdin
**** file
**** socket
**** random number
**** date/time
**** env variable
**** command line arg
*** throws exception
*** dir/file operations
*** process operations
*** signal operations
*** thread operations?
*** http operations
*** database operations
** exec for language
** alternatives
- name: ...
  alts
  - name: default/...
    type: in library/in file/code
    location: ...
    code: ...
    setup code?: ...
    teardown code?: ...
    sensor?: ...
    mutator/replacement?: ...
*** replace dep with constant
*** replace dep with fixture get
*** replace dep with random
*** replace dep with next
*** replace output with nop
*** wrap dep with fixture set
*** wrap with setup/teardown(|undo)
** test
** thor
=end
