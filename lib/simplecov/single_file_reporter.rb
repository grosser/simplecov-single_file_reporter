require "simplecov"

class SimpleCov::SingleFileReporter
  VERSION = "0.0.0"

  ANSI_COLOR_CODE = {
    :red    => "\e[31m",
    :green  => "\e[32m",
    :yellow => "\e[33m"
  }

  ANSI_COLOR_CODE_TERMINATOR = "\e[0m"

  class << self
    def print
      SimpleCov.start
      return unless ARGV.empty? && File.exist?($0)
      SimpleCov.at_exit do
        SimpleCov.result.format! # keep generating default report so people can see why the coverage is not 100%
        puts coverage_for($0)
      end
    end

    def coverage_for(test_file)
      if file = file_under_test(test_file)
        if percent = covered_percent(file)
          message(file, percent)
        else
          "Could not find coverage for file #{file} in Simplecov report"
        end
      else
        "Could not find tested file for #{test_file}"
      end
    end

    def covered_percent(file)
      data = SimpleCov.result.files.detect { |f| f.filename =~ /#{Regexp.escape file}$/ }
      data.covered_percent.round(2) if data
    end

    private

    # TODO: Make this work for models, helpers, lib, etc
    def file_under_test(test_file)
      file = test_file.split("test/").last.
        sub("functional/", "controllers/").
        sub("_test.rb", ".rb").
        sub(%r{(^|/)test_([^/]+\.rb)}, "\\1\\2")

      possibilities = ["app", "lib"].map { |f| "#{f}/#{file}" }
      possibilities.detect { |f| File.exist?(f) }
    end

    def color?
      STDOUT.tty?
    end

    def message(file, percent)
      message = "#{file} coverage: #{percent}"
      if color?
        "#{ANSI_COLOR_CODE.fetch(color(percent))}#{message}#{ANSI_COLOR_CODE_TERMINATOR}"
      else
        message
      end
    end

    def color(percent)
      if percent == 100.0
        :green
      elsif percent > 90
        :yellow
      else
        :red
      end
    end
  end
end
