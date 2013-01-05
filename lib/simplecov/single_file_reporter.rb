require "simplecov"

class SimpleCov::SingleFileReporter
  VERSION = "0.0.0"

  ANSI_COLOR_CODE = {
    :red    => "\e[31m",
    :green  => "\e[32m",
    :yellow => "\e[33m"
  }

  ANSI_COLOR_CODE_TERMINATOR = "\e[0m"

  def self.print
    SimpleCov.start
    return unless ARGV.empty? && File.exist?($0)
    SimpleCov.at_exit do
      SimpleCov.result.format! # keep generating default report so people can see why the coverage is not 100%
      puts coverage_for($0)
    end
  end

  def self.coverage_for(test_file)
    new(test_file).coverage
  end

  attr_reader :file_under_test

  def initialize(test_file)
    @test_file = test_file
  end

  def coverage
    if File.exist?(file_under_test)
      extract_covered_percent
    else
      "Could not find file: #{file_under_test}"
    end
  end

  def covered_percent
    @covered_percent ||= file_coverage.covered_percent.round(2) if file_coverage
  end

  private

  # TODO: Make this work for models, helpers, lib, etc
  def file_under_test
    @file_under_test ||= begin
      file = @test_file.split("test/").last.
        sub("functional/", "controllers/").
        sub("_test.rb", ".rb").
        sub(%r{(^|/)test_([^/]+\.rb)}, "\\1\\2")

      possibilities = ["app", "lib"].map { |f| "#{f}/#{file}" }
      possibilities.detect { |f| File.exist?(f) } || possibilities.last
    end
  end

  def extract_covered_percent
    if covered_percent
      color? ? colored_message : message
    else
      "Could not find #{file_under_test} in Simplecov report"
    end
  end

  def color?
    STDOUT.tty?
  end

  def message
    @message ||= "#{file_under_test} coverage: #{covered_percent}"
  end

  def colored_message
    "#{ansi_color_code}#{message}#{ANSI_COLOR_CODE_TERMINATOR}"
  end

  def ansi_color_code
    color = if covered_percent == 100.0
      :green
    elsif covered_percent > 90
      :yellow
    else
      :red
    end
    ANSI_COLOR_CODE.fetch(color)
  end

  def file_coverage
    @file_coverage ||= SimpleCov.result.files.detect do |file|
      file.filename =~ /#{Regexp.escape file_under_test}$/
    end
  end
end
