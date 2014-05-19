#!/usr/bin/env ruby
require_relative 'lib/retrieve4me.rb'
require 'logger'
require 'trollop'
require 'json'
#require 'pp'

@log = Logger.new(STDOUT)
@log.level = Logger::DEBUG
@log.datetime_format = "%Y-%m-%d %H:%M:%S"

opts = Trollop::options do
  version "0.5.0"
  banner <<-EOS
Usage:
       retrieve4me.rb [options] <filenames>+
where [options] are:
EOS

  opt :dry, "Issue a dry-run"
  opt :all, "See all files listed by the rest end point"
  #opt :file, "Extra data filename to read in, with a very long option description like this one",
  #      :type => String
  #opt :volume, "Volume level", :default => 3.0
  #opt :iters, "Number of iterations", :default => 5
end
#Trollop::die :volume, "must be non-negative" if opts[:volume] < 0
#Trollop::die :file, "must exist" unless File.exist?(opts[:file]) if opts[:file]


#Use END so we can use methods before they are defined..
END {

if opts[:dry] && opts[:all]
  puts get_rest_data_pretty
elsif opts[:dry]
  #puts get_rest_data
  #puts get_rest_data_pretty
  #puts get_local_data
 # puts find_matches(get_rest_data_pretty, get_local_data)
  puts file_to_retrieve(get_rest_data_pretty, get_local_data)
  #fs_parser.set_items
  #puts fs_parser.get_items
  #code
end
}

def file_to_retrieve(rest_array, local_array)
  #requires 2 arrays
  #Loops through both arrays, checks for string matches for each element
  #if a match is found, it skips the item.  If a match is not found, it adds it to the matches array
  matches_found = []
  matches_array  = []

  local_array.each do |local_element|
	break_out = false
  	rest_array.each do |rest_element|
      if File_matcher.calculate_long_match(rest_element, local_element) > 0.90
        @log.debug("rest element match: #{rest_element}")
				matches_found << rest_element
		#		break_out = true
      end
		#break if break_out == true	
    end
    #if file_to_do
    #  @log.debug("adding rest element to download array: #{rest_element}")
    #  matches_array << rest_element
    #end
  end

  #matches_array
  rest_array - matches_found.uniq!
end

def find_matches(rest_array, local_array)
  #requires 2 arrays
  #look for items in a1 that are also in a2.  if there is a match, store it in matches_array
#  matches_array = a1.select {|item| !a2.grep(item).empty?}
  matches_array  = []
  rest_array.each do |element|
    if ! local_array.grep(element).empty?
      matches_array << element
    end
  end

  matches_array
end

def get_rest_data
  rest_client = Rest_Client.new
  if rest_client.fetch
    rest_client.response_body
  end
end

def get_rest_data_pretty
  return_array = []

  JSON.load(get_rest_data).each do |item|
    return_array << item['name']
  end

  return_array

end

def get_local_data
  fs_parser = Filesystem_Parser.new
  fs_parser.set_items
  fs_parser.get_items
end
#log.debug("get_items: #{fs_parser.get_items}")
#log.debug("set_items: #{fs_parser.set_items}")
#puts fs_parser.set_items
