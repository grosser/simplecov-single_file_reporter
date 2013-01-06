$LOAD_PATH.unshift File.expand_path("../../../../lib", __FILE__)
require 'simplecov/single_file_reporter'
SimpleCov.root(File.expand_path("../../", __FILE__))
SimpleCov.start
SimpleCov::SingleFileReporter.print
