require 'test/unit'
require './init'
require './formatter'

class TestCommandLine < Test::Unit::TestCase
  def test_get_formatter_klass
    assert_equal LineFormatter, get_formatter_klass('linenumbers')
    assert_equal VimOutPutFormatter, get_formatter_klass('vim')
    assert_equal TextOutputFormatter, get_formatter_klass('text')
    assert_equal VimOutPutFormatter, get_formatter_klass('foo')
  end
end
