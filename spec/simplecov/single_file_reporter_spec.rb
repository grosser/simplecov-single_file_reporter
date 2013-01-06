require "spec_helper"

describe SimpleCov::SingleFileReporter do
  def self.in_folder(folder)
    around do |example|
      Dir.chdir fixtures.join(folder) do
        example.call
      end
    end
  end

  def self.it_shows_correct_coverage_reports(options={})
    it "shows percentage after single file is run" do
      result = run(options[:run] || "ruby test/test_a.rb")
      result.should include("Coverage report generated")
      result.should include(options[:result_run] || "1 tests, 1 assertions")
      result.should include("lib/a.rb coverage: 80.0")
    end

    it "does not show percentage for rake" do
      result = run("rake")
      result.should include("Coverage report generated")
      result.should include(options[:result_rake] || "1 tests, 1 assertions")
      result.should_not include("lib/a.rb coverage")
    end
  end

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

    it "finds spec" do
      test_find "spec/xxx_spec.rb", "lib/xxx.rb"
    end
  end

  context "in a test-unit project" do
    in_folder "test-unit-project"
    it_shows_correct_coverage_reports
  end

  context "in a minitest project" do
    in_folder "minitest-project"
    it_shows_correct_coverage_reports
  end

  context "in a rspec project" do
    in_folder "rspec-project"
    it_shows_correct_coverage_reports(
      :run => "rspec spec/a_spec.rb",
      :result_rake => "2 examples, 0 failures",
      :result_run => "1 example, 0 failures",
    )
  end

  private

  def run(command)
    result = `#{command} 2>&1`
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
