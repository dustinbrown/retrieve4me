#!/usr/bin/env ruby
require_relative '../myconfig.rb'
#require 'net/http'
require 'net/https'
require 'uri'

class Rest_Client

  #load config files
  #config = MyConfig.new
  @@items_on_disk = []
  attr_accessor :response_body

  def initialize(config={})

    if config.empty?
      config = MyConfig.new

      @host_url = config.attrs[:host_url]
      @username = config.attrs[:username]
      @password = config.attrs[:password]
      @path     = config.attrs[:download_path]
    else
      @host_url = config[:host_url]
      @username = config[:username]
      @password = config[:password]
      @path     = config[:download_path]
    end
  end

  def fetch
    #uri = URI(@host_url)
    uri = URI.parse(@host_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri.request_uri)
    #request = Net::HTTP::Get.new(uri)
    request.basic_auth @username, @password

    response = http.request(request)
    #response.body
    #response.status
    #exit

  #begin
  #  response = Net::HTTP.start(uri.hostname, uri.port) do |myhttp|
  #    myhttp.request(request)
  #  end
  #rescue Errno::ECONNREFUSED, /Connection refused/
  # # raise RuntimeError, "Sinatra app appears offline"
  #  puts "Error: Cannot connect to #{@host_url}"
  #  exit 1
  #end
    if response.code == "200"
      @response_body = response.body 
      #puts response_body
      return true
    else
      return false
    end
    #puts response.body
  end

  def set_items
    #Build array and store it in a class array
    get_items_in_path(@path).each do |item|
      @@items_on_disk << item
    end
    #@@items_on_disk
  end

  def get_items_in_path(path)
    #does the path exist?
    if File.directory? path

      #loop through files and directories in path
      Dir.open(path).to_a.each do |file_or_dir|
        #skip dot files
        next if file_or_dir =~ /^\./

        #convienence var
        full_path = "#{path}/#{file_or_dir}"

        #Store file and directory names into instance var
        if File.directory?(full_path)
          @item_array << file_or_dir

          #if full_path is a dir, use recursion to keep travelling into the directory
          get_items_in_path(full_path)

        else
          @item_array << file_or_dir
        end
      end
    end
    @item_array
  end
end

