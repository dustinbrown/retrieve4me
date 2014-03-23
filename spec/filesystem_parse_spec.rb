#!/usr/bin/env ruby

require_relative '../lib/filesystem_parser.rb'

RSpec.configure do |config|
  config.mock_framework = :mocha
end

describe 'Retreive4me' do
  let(:fs_parser) { Filesystem_Parser.new }
  
  it 'get_items should return array of files' do
    fs_parser.get_items.class.should == Array
  end
    
  it 'set_items return array' do
    fs_parser.stubs(:get_items_in_path).returns([1,2])
    fs_parser.set_items.should == [1,2]
  end
end