print coverage for 1 test/spec file

Install
=======

    gem install simplecov-single_file_reporter

Usage
=====

### Simple setup

Print coverage percent when you run a single file

```Ruby
require "simplecov/single_file_reporter"
SimpleCov.start
SimpleCov::SingleFileReporter.print
```

```Bash
ruby test/a_test.rb
1 tests, 1 assertions
lib/a.rb coverage: 80.0
```

### Customizing file-finding rules

SingleFileReporter needs to find the file that is tested.
```
test/test_xxx.rb -> lib/xxx.rb or app/xxx.rb
```

If it's something common, make a pull request.<br/>
If your app has special rules you can add them:

```Ruby
class MyReporter < SimpleCov::SingleFileReporter
  remove :file_under_test
  def self.file_under_test(test_file)
    super(test_file) || test_file.split("test/").last.sub("foo", "bar").sub("_test.rb", ".rb")
  end
end

SimpleCov.start
MyReporter.print
```

Authors
======

### [Contributors](https://github.com/grosser/simplecov-single_file_reporter/contributors)
 - [Eirik Dentz Sinclair](https://github.com/edsinclair)

[Michael Grosser](http://grosser.it)<br/>
michael@grosser.it<br/>
License: MIT<br/>
[![Build Status](https://travis-ci.org/grosser/simplecov-single_file_reporter.png)](https://travis-ci.org/grosser/simplecov-single_file_reporter)
