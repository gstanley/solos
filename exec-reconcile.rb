# this is a reconcile of previous versions of art/exec
# final goal is to merge back into another one of these systems
# exec types:
# - just exec
# - exec with params
# - exec multiple times (w/ params)
# - exec with deps
# - exec with alternate dep
#   - from value
#   - from fixture
#   - from random
#   - alternate function calls
# - exec alternate (same language)
# - exec with language specified
# - generate
# - doc
# - index terms (doc and keywords)
# - missing info
# - parse
#
# main exec takes a map with "source" => "..."
# todo: search for instances of exec or art
# add exec with yaml (calls regular exec)
# add exec with defaults (merges a default map)
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

def generate(artifact)
  artifact["source"]
end

def execute(artifact)
  eval generate(artifact)
end

def doc(artifact)
  artifact["doc"]
end

if __FILE__ == $0
  # run like: ruby exec-reconcile.rb -- --test
  if ARGV[1] == "--test"
    require 'test/unit'

    class TestExec < Test::Unit::TestCase
      def setup
        @command1 = {"source" => "1 + 2 + 3",
                     "doc" => "add 1, 2, 3"}
      end

      test "basic execute" do
        assert_equal 6, execute(@command1)
      end

      test "basic generate" do
        assert_equal "1 + 2 + 3", generate(@command1)
      end

      test "doc" do
        assert_equal "add 1, 2, 3", doc(@command1)
      end
    end
  end
end
