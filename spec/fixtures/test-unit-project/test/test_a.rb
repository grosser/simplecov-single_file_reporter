require 'test/unit'

# Setup SimpleCov
$LOAD_PATH.unshift File.expand_path("../../../../lib", __FILE__)
require 'simplecov/single_file_reporter'
SimpleCov.root(File.expand_path("../../", __FILE__))
SimpleCov::SingleFileReporter.print

# Load file under test
$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "a"

class ATest < Test::Unit::TestCase
  def test_a
    assert true
  end
end

