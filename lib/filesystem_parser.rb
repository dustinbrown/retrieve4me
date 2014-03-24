#!/usr/bin/env ruby
require_relative '../myconfig.rb'

class Filesystem_Parser

  @@items_on_disk = []

  def initialize#(config)
    #load config files
    config = MyConfig.new
    @path = config.attrs[:download_path]
    @item_array = []
    #set_items
    #code
    # set items_on_disk
  end

  def get_items
    @@items_on_disk
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

