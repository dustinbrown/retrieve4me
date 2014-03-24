#!/usr/bin/env ruby
require_relative 'lib/retrieve4me.rb'
require 'logger'
require 'trollop'
#require 'pp'

log = Logger.new(STDOUT)
log.level = Logger::DEBUG
log.datetime_format = "%Y-%m-%d %H:%M:%S"

opts = Trollop::options do
  version "0.5.0"
  banner <<-EOS
Usage:
       retrieve4me.rb [options] <filenames>+
where [options] are:
EOS

  opt :dry, "Issue a dry-run"
  #opt :file, "Extra data filename to read in, with a very long option description like this one",
  #      :type => String
  #opt :volume, "Volume level", :default => 3.0
  #opt :iters, "Number of iterations", :default => 5
end
#Trollop::die :volume, "must be non-negative" if opts[:volume] < 0
#Trollop::die :file, "must exist" unless File.exist?(opts[:file]) if opts[:file]

fs_parser = Filesystem_Parser.new

if opts[:dry]
  fs_parser.set_items
  puts fs_parser.get_items
  #code
end

#log.debug("get_items: #{fs_parser.get_items}")
#log.debug("set_items: #{fs_parser.set_items}")
#puts fs_parser.set_items