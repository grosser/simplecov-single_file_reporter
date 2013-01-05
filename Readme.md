print coverage per test file

Install
=======

    gem install simplecov-single_file_reporter

Usage
=====

### Simple setup

Print coverage percent when you run a single file

```Ruby
require "simplecov/single_file_reporter"
Simplecov::SingleFileReporter.print
```

```Bash
ruby test/xxx_test.rb

```

### Customizing file-finding rules

```Ruby
class MyReporter < SimpleCov::SingleFileReporter
  remove :file_under_test
  def file_under_test
    @test_file.gsub("subfolder", "app")
  end
end
```

### Using percentage for something else

```Ruby
reporter = SimpleCov::SingleFileReporter.new("test/xxx_test.rb")
puts reporter.coverage
puts reporter.covered_percent
```

Author
======


EROIC


[Michael Grosser](http://grosser.it)<br/>
michael@grosser.it<br/>
License: MIT<br/>
[![Build Status](https://travis-ci.org/grosser/simplecov-single_file_reporter.png)](https://travis-ci.org/grosser/simplecov-single_file_reporter)
