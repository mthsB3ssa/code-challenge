#!/usr/bin/env ruby
require 'bundler/setup'
require 'optparse'
require_relative 'lib/carousel_parser'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: run.rb [options]"
  opts.on("-fFILE", "--file=FILE", "HTML file to parse") do |f|
    options[:file] = f
  end
end.parse!

unless options[:file]
  puts "Error: please specify an HTML file with -f or --file"
  exit 1
end

parser = CarouselParser.new(options[:file])
puts parser.to_json
