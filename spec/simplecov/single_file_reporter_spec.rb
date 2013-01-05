require "spec_helper"

describe SimpleCov::SingleFileReporter do
  let(:fixtures){ Bundler.root.join("spec", "fixtures") }

  it "has a VERSION" do
    SimpleCov::SingleFileReporter::VERSION.should =~ /^[\.\da-z]+$/
  end

  context "in a test-unit project" do
    around do |example|
      Dir.chdir fixtures.join("test-unit-project") do
        example.call
      end
    end

    it "shows percentage after single file is run" do
      result = run("ruby test/test_a.rb")
      result.should include("Coverage report generated")
      result.should include("1 tests, 1 assertions")
      result.should include("lib/a.rb coverage: 80.0")
    end

    it "does not show percentage for rake" do
      result = run("rake")
      result.should include("Coverage report generated")
      result.should include("1 tests, 1 assertions")
      result.should_not include("lib/a.rb coverage")
    end
  end



  private

  def run(command)
    result = `#{command}`
  ensure
    raise "FAILED: #{result}" unless $?.success?
  end
end
