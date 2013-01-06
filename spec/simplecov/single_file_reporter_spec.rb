require "spec_helper"

describe SimpleCov::SingleFileReporter do
  let(:fixtures){ Bundler.root.join("spec", "fixtures") }

  it "has a VERSION" do
    SimpleCov::SingleFileReporter::VERSION.should =~ /^[\.\da-z]+$/
  end

  describe ".color" do
    [[100, :green], [99, :yellow], [91, :yellow], [90, :red], [0, :red]].each do |percent, color|
      it "shows #{color} for #{percent}" do
        call(:color, percent).should == color
      end
    end
  end

  describe ".message" do
    it "is plain for none-tty" do
      STDOUT.stub(:tty?).and_return(false)
      call(:message, "xxx.rb", 10).should == "xxx.rb coverage: 10"
    end

    it "is colored for tty" do
      STDOUT.stub(:tty?).and_return(true)
      call(:message, "xxx.rb", 10).should == "\e[31mxxx.rb coverage: 10\e[0m"
    end
  end

  describe ".file_under_test" do
    around do |example|
      tmp = fixtures.join("tmp")
      `rm -rf #{tmp}`
      `mkdir -p #{tmp}`
      begin
        Dir.chdir tmp do
          example.call
        end
      ensure
        `rm -rf #{tmp}`
      end
    end

    it "does not find unfindable" do
      touch "lib/xxx.rb"
      call(:file_under_test, "yyy.rb").should == nil
    end

    it "finds files in lib via _test.rb" do
      test_find "test/xxx_test.rb", "lib/xxx.rb"
    end

    it "finds files in lib via test_*.rb" do
      test_find "test/test_xxx.rb", "lib/xxx.rb"
    end

    it "finds files in app" do
      test_find "test/xxx_test.rb", "app/xxx.rb"
    end

    it "finds nested files" do
      test_find "test/foo/bar/xxx_test.rb", "lib/foo/bar/xxx.rb"
    end

    it "finds functional as app/controllers" do
      test_find "test/functional/xxx_controller_test.rb", "app/controllers/xxx_controller.rb"
    end

    it "finds test/unit/xxx as app/xxx" do
      test_find "test/unit/xxx_test.rb", "app/xxx.rb"
    end

    it "finds test/unit/xxx as lib/xxx" do
      test_find "test/unit/xxx_test.rb", "lib/xxx.rb"
    end

    it "finds test/unit/lib/xxx as lib/xxx" do
      test_find "test/unit/lib/xxx_test.rb", "lib/xxx.rb"
    end
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

  def call(name, *args)
    SimpleCov::SingleFileReporter.send(name, *args)
  end

  def touch(file)
    run "mkdir -p #{File.dirname(file)} && touch #{file}"
  end

  def test_find(test, file)
    touch file
    touch test
    call(:file_under_test, test).should == file
  end
end