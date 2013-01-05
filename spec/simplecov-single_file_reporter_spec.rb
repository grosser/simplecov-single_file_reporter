require "spec_helper"

describe Simplecov::SingleFileReporter do
  it "has a VERSION" do
    Simplecov::SingleFileReporter::VERSION.should =~ /^[\.\da-z]+$/
  end
end
