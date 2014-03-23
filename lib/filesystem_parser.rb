#!/usr/bin/env ruby
require_relative '../myconfig.rb'

class Filesystem_Parser


  @@items_on_disk = []
  
  
  def initialize#(config)
    #load config files
    config = MyConfig.new
    @path = config.attrs[:path]
    @item_array = []
    #code
    # set items_on_disk
  end
  
  def get_items
    @@items_on_disk
  end
  
  def set_items
    #Build array
    get_items_in_path(@path).each do |item|
      #next if item =~ /^\./
      @@items_on_disk << item
    end
    @@items_on_disk
  end
  
  def get_items_in_path(path)
    #Dir.open(path).to_a if File.directory? path
    if File.directory? path
      Dir.open(path).to_a.each do |file_or_dir|
        next if file_or_dir =~ /^\./
        full_path = "#{path}/#{file_or_dir}"
        
        if File.directory?(full_path)
          @item_array << file_or_dir
          get_items_in_path(full_path)
        else
          @item_array << file_or_dir
        end
        
      end
    end
    @item_array
  end
  
end

