require "minitest/autorun"
require File.expand_path("../../../setup_simple_print.rb", __FILE__)

# Load file under test
$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "a"

class ATest < MiniTest::Unit::TestCase
  def test_a
    assert true
  end
end

