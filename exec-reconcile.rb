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
#
# main exec takes a map with "source" => "..."
# todo: search for instances of exec or art
# add exec with yaml (calls regular exec)
# add exec with defaults (merges a default map)

if __FILE__ == $0
  # run like: ruby exec-reconcile.rb -- --test
  if ARGV[1] == "--test"
    require 'test/unit'

    class TestExec < Test::Unit::TestCase
      def setup
      end

      def test_example
        flunk "start..."
      end
    end
  end
end
