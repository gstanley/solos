# this is a reconcile of previous versions of art/exec
# final goal is to merge back into another one of these systems
# exec types:
# - *just exec
# - *exec with params
# - exec multiple times (w/ params)
# - *exec with deps
# - exec with alternate dep
#   - from value
#   - from fixture
#   - from random
#   - alternate function calls
# - exec alternate (same language)
# - exec with language specified
# - *generate
# - *doc
# - index terms (doc and keywords)
# - missing info
# - parse
# - char tests?
# - exec with value trace
#
# main exec takes a map with "source" => "..."
# todo: search for instances of exec or art
# add exec with yaml (calls regular exec)
# add exec with defaults (merges a default map)
# emacs helpers
# - xiki?
# - org-babel helpers
# implement cutpoints
# - before line
#   - show location
#   - show value of inputs/dependencies
#     - or save value of inputs/dependencies
#   - change value of inputs/dependencies
# - at line
#   - replace line
# - after line
#   - show value of outputs/results
# implement cutpoint helpers
# - ruby
# - javascript
# - java
# - clojure? (may be already integrated with exec functionality)
#
# merge params both ways
# - artifacts specialize default parameters
# - some default parameters are protected (artifacts don't change them)
# - artifacts add to default lists

require "erb"
require "ostruct"

def generate(artifact)
  p = OpenStruct.new(artifact["params"])
  b = binding
  ERB.new(artifact["source"], nil, '-').result(b)
end

def wrap_code(code, wrappers)
  if wrappers.nil? || wrappers.empty?
    code
  else
    wrapper = wrappers.first
    pre = wrapper["pre"] || ""
    post = wrapper["post"] || ""
    new_code = code
#    if wrapper["pre"]
#      new_code = [wrapper["pre"], 
  end
end

def surrounding_code(wrappers)
  result = [["require \"ostruct\"", ""],
            ["___result = OpenStruct.new", ""]]

  result
end

def split_last_expression_and_previous(code)
  lines = code.chomp.split("\n")
  [lines[0..-2].join, lines.last]
end

def execute(artifact)
  code = wrap_code([artifact["dep"].to_s, generate(artifact)].join("\n"), artifact["wrappers"])
  result = eval code
  result
end

def doc(artifact)
  artifact["doc"]
end

if __FILE__ == $0
  # run like: ruby exec-reconcile.rb -- --test
  if ARGV[1] == "--test"
    require 'test/unit'
    require 'byebug'

    class TestExec < Test::Unit::TestCase
      def setup
      end

      test "basic execute" do
debugger
        assert_equal 3, execute({"source" => "1 + 2"})
      end

      test "basic generate" do
        assert_equal "1 + 2 + 3", generate({"source" => "1 + 2 + 3"})
      end

      test "doc" do
        assert_equal "add 1, 2, 3", doc({"source" => "1 + 2 + 3",
                                         "doc" => "add 1, 2, 3"})
      end

      test "execute with dep" do
        assert_equal 100, execute({"source" => "a * a",
                                   "dep" => "a = 10"})
      end

      test "execute generated code from template" do
        assert_equal 23, execute({"source" => "<%= 23 %>"})
      end

      test "generate and execute code with params" do
        art = {"source" => '"Hello <%= p.a %>"',
               "params" => {"a" => "Bob"}}
        assert_equal '"Hello Bob"', generate(art)
        assert_equal "Hello Bob", execute(art)
      end

      # uses "wrappers" which is general custom before/after code
      # dependencies and executors are types of wrappers
      # pre: code added before
      # sensors: results brought outside
      test "execute w/ dependencies" do
        art = {"source" => "b = a",
               "wrappers" => [
                 {"pre" => "a = 10"},
                 {"sensors" => "b"}]}
        assert_equal 10, execute(art).b
      end

      test "split last expression and previous" do
        code = <<END
a = 23
a
END
        result = split_last_expression_and_previous(code)
        assert_equal "a = 23", result[0]
        assert_equal "a", result[1]
      end
#      test "execute code that outputs to console" do
#        art = {"source" => <<EOS,
#puts "Hello <%= p.name %>"
#23
#EOS
#               "params" => {"name" => "Carol"}}
#        assert_equal "Hello Carol", execute(art)
#      end
    end
  end
end
# * wrapped
# require "ostruct"
# ___result = OpenStruct.new
# a = 10
# ___result["<result>"] = (
# b = a
# )
# ___result["b"] = b
#
# 'b = a' #code
# '___result["<result>"] = (', code, ')' #store_result
# a = 10 #pre
# nil #post
# pre, store_result, post #around_code
# --- could be more around_code blocks
# ___result = OpenStruct.new #create_result
# create_result, around_code, nil #code_with_result_store
# ___result["b"] = b #sensor
# --- could be more sensors
# nil, code_with_result_store, sensor #code_with_sensors
# require "ostruct" #require_for_openstruct
# require_for_openstruct, code_with_sensors, nil #wrapped_code
