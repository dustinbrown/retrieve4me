#!/usr/bin/env ruby
require_relative 'lib/retrieve4me.rb'
require 'logger'

log = Logger.new(STDOUT)
log.level = Logger::DEBUG
log.datetime_format = "%Y-%m-%d %H:%M:%S"

fs_parser = Filesystem_Parser.new

log.debug("get_items: #{fs_parser.get_items}")
log.debug("set_items: #{fs_parser.set_items}")
#puts fs_parser.set_items