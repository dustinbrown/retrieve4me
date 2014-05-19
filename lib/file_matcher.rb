#!/usr/bin/env ruby
# AUTHOR:   deeje
# FILE:     file_matcher.rb
# ROLE:     TODO (some explanation)
# CREATED:  2014-05-05 20:40:02
# MODIFIED: 2014-05-18 19:15:38
require 'logger'

module File_matcher
  #intialize logging
  @log = Logger.new(STDOUT)
  @log.level = Logger::DEBUG
  @log.formatter = proc do |severity, datetime, progname, msg|
      "#{datetime}: #{severity}: #{msg}\n"
  end
  #@log.datetime_format = "%Y-%m-%d %H:%M:%S"

  #method to calculate word matches between 2 strings
  def File_matcher.calculate_long_match(first, second)
    match = 0.0

    #split strings into arrays so we can compare words -- splitting on dots and whitespace
    first_array = first.split(/\.|\s/)
    second_array = second.split(/\.|\s/)

    #determine the longest array
    first_array.length > second_array.length ? array_length = first_array.length : array_length = second_array.length

    #loop through arrays and find word matches
    first_array.each do |first_element|
      second_array.each do |second_element|
        if first_element.downcase == second_element.downcase
          @log.debug("string match: #{first_element}:#{second_element}")
          match += 1
        end
      end
    end

    #Calculate percentage for word matching
    match_percentage = match / array_length
    @log.debug("match = #{match}")
    @log.debug("word match % = #{match_percentage}")

    return match_percentage

  end

end
 #File_matcher.calculate_long_match('enders.Game 2013test season  HC.Webrip.x264.AC3.TiTAN', 'Enders Game 2013 HC Webrip x264 AC3 TiTAN')
