#!/usr/bin/env ruby
# AUTHOR:   deeje
# FILE:     file_matcher.rb
# ROLE:     TODO (some explanation)
# CREATED:  2014-05-05 20:40:02
# MODIFIED: 2014-05-18 19:15:38
require 'logger'
require_relative '../myconfig.rb'

config = MyConfig.new

@ftp_password = config.attrs[:ftp_password]
@ftp_url 			= config.attrs[:ftp_url]
@username 		= config.attrs[:username]

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
lftp -u #{@username},#{@ftp_password} #{@ftp_url}
cd complete
			EOS
		transfer_list.each do |media|
			if media[:file_type] == "dir"
				transfer_file.puts "mirror #{media[:file_name]}"
			#transfer_file.puts "mirror #{transfer_list[:dir]}"
			elsif media[:file_type] == "file"
				transfer_file.puts "pget #{media[:file_name]}"	
			end
 		end

		transfer_file.puts "quit"
		transfer_file.close

	end

	def Lftp.execute_transfer
		system('cd /video/complete && /usr/local/bin/lftp -f /tmp/transfer_file')

	end
end
