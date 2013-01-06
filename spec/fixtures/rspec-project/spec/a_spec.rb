require File.expand_path("../../../setup_simple_print.rb", __FILE__)

# Load file under test
$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "a"

describe "A" do
  it "is true" do
    true.should == true
  end
end

