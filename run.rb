require 'optparse'
require 'json'
require 'awesome_print'
require 'active_support/inflector'

require_relative 'cmd_utilities'
require_relative 'rails_builder'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: run.rb [path]"

  opts.on("-h", "--help", "Asking for help") do |h|
    options[:help] = h
  end

  opts.on("-i", "--input-path PATH", "JSON specification file path") do |i|
    options[:input_path] = i
  end

  opts.on("-o", "--output-path PATH", "Rails Project path were commands will run") do |o|
    options[:output_path] = o
  end
end.parse!

help_message = "Example Usage: rails_builder/ruby run.rb -i path/to/input/json/spec.json -o path/to/rails/project/folder"

print_help_and_exit if options[:help]

unless options[:input_path] && options[:output_path]
  p "You must specify a input file and output folders. See:"
  print_help_and_exit
end

begin
  input_json = File.read( options[:input_path] )
rescue
  p "You must specify a valid input file. see:"
  print_help_and_exit
end

begin
  data_hash = JSON.parse(input_json)
  raise unless data_hash
rescue
  p "You must specify a valid input file. see:"
  print_help_and_exit
end

RailsBuilder.new( data_hash, options[:output_path] ).run
