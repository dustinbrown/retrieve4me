#!/usr/bin/env ruby
# AUTHOR:   deeje
# FILE:     file_matcher.rb
# ROLE:     TODO (some explanation)
# CREATED:  2014-05-05 20:40:02
# MODIFIED: 2014-05-18 19:15:38
require 'logger'

module Lftp
  #intialize logging
  @log = Logger.new(STDOUT)
  @log.level = Logger::INFO
  @log.formatter = proc do |severity, datetime, progname, msg|
      "#{datetime}: #{severity}: #{msg}\n"
  end
  #@log.datetime_format = "%Y-%m-%d %H:%M:%S"

	def Lftp.build_file(transfer_list)
		transfer_file = File.new("/tmp/transfer_file", "w")
			transfer_file.puts <<-EOS
set net:connection-limit 4
set pget:default-n 12
set ftps:initial-prot
set ftp:ssl-force true
set ftp:ssl-protect-data true
set mirror:use-pget-n 4
set mirror:parallel-transfer-count 2
set mirror:parallel-directories true
lftp -u deeje,clownsgameboardblue sftp://deeje.aireservers.com
cd complete
			EOS
		if transfer_list[:dir]
			transfer_list[:dir].each do |dir|
				transfer_file.puts "mirror #{dir}"
			#transfer_file.puts "mirror #{transfer_list[:dir]}"
			end
 		end

		if transfer_list[:file]
			transfer_file.puts "pget #{transfer_list[:file].join(' ')}"
		end

		transfer_file.puts "quit"
		transfer_file.close

	end

	def Lftp.execute_transfer

	end
end
my_hash = { :file => ['file1'] }
#my_hash = { :dir => ['dir1', 'dir2'], :file => ['file1', 'file2'] }
Lftp.build_file(my_hash)
