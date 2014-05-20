#!/usr/bin/env ruby
require_relative 'lib/retrieve4me.rb'
require 'logger'
require 'trollop'
require 'json'
#require 'pp'

@log = Logger.new(STDOUT)
@log.level = Logger::INFO
@log.datetime_format = "%Y-%m-%d %H:%M:%S"

opts = Trollop::options do
  version "0.5.0"
  banner <<-EOS
Usage:
       retrieve4me.rb [options] <filenames>+
where [options] are:
EOS

  opt :all, "See all files listed by the rest end point"
  opt :dry, "Issue a dry-run"
	opt :list, "list rest files"
	opt :override, "Enter override file name, can be regex", :type => :string
	opt :pull, "Initiate lftp pull"
  #opt :file, "Extra data filename to read in, with a very long option description like this one",
  #      :type => String
  #opt :volume, "Volume level", :default => 3.0
  #opt :iters, "Number of iterations", :default => 5
end
#Trollop::die :volume, "must be non-negative" if opts[:volume] < 0
#Trollop::die :file, "must exist" unless File.exist?(opts[:file]) if opts[:file]


#Use END so we can use methods before they are defined..
END {

	puts get_rest_data_pretty 																	if opts[:dry] && opts[:all]

	puts file_to_retrieve(get_rest_data_pretty, get_local_data) if opts[:dry]

	puts get_rest_data_pretty																		if opts[:list]

	puts find_override(opts[:override], get_rest_data_pretty)		if opts[:override]

	if opts[:override] && opts[:pull]
		override_hash = find_override(opts[:override], get_rest_data_pretty("array_of_hashes"))
		Lftp.build_file(override_hash)
		Lftp.execute_transfer
	end

  #puts get_rest_data
  #puts get_rest_data_pretty
 # puts get_local_data
	#lines_array = IO.readlines("/home/dbrown/git/retrieve4me/media.txt")
 # puts find_matches(get_rest_data_pretty, get_local_data)
  #puts file_to_retrieve(get_rest_data_pretty, get_local_data)
  #fs_parser.set_items
  #puts fs_parser.get_items
  #code
}

def find_override(override, rest_array)
	return_array = []
	rest_array.each do |media|
		if media.class == Hash
			if media[:file_name] =~ /#{override}/
				return_array << media
			end
		#else
		#	return_array << rest_array.select{|filename| filename.match(/#{override}/)}
		end
	end
	
	return_array
end

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

def get_rest_data_pretty(type="array")
  return_array = []
	return_array_of_hashes = []

  JSON.load(get_rest_data).each do |item|
    return_array << item['name']
		return_hash = { :file_name => item['name'], :file_type => item['type'] }
		return_array_of_hashes << return_hash
  end
	
	#if type == "array"
  #	return_array
	#else
		return_array_of_hashes
	#end

end

def get_local_data
	if File.exists? "media.txt"
		lines_array = IO.readlines("media.txt")
		lines_array
	else	
  	fs_parser = Filesystem_Parser.new
  	fs_parser.set_items
  	fs_parser.get_items
	end
end
#log.debug("get_items: #{fs_parser.get_items}")
#log.debug("set_items: #{fs_parser.set_items}")
#puts fs_parser.set_items
