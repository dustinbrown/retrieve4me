#!/usr/bin/env ruby
require_relative '../lib/retrieve4me.rb'

RSpec.configure do |config|
  config.mock_framework = :mocha
end

describe 'Retreive4me' do
  #let(:fs_parser) { Filesystem_Parser.new }
  #let(:script_path) {'/home/deeje/git/ruby/retrieve4me/retrieve4me.rb'}
#  let(:script_path) {'../retrieve4me.rb'}
  RUBY_BIN = '/usr/bin/ruby'
  SCRIPT_PATH = '/home/deeje/git/ruby/retrieve4me/retrieve4me.rb'
  
  it 'should return array when -d is passed' do
    `#{RUBY_BIN} #{SCRIPT_PATH} -d`.class.should  == Array 
 #   `#{RUBY}  /home/deeje/git/ruby/retrieve4me/retrieve4me.rb -d`.class.should  == Array 
#    `#{RUBY} #{:script_path} -d`.class.should  == Array 
  end
    
  #it 'set_items return array' do
  #  fs_parser.stubs(:get_items_in_path).returns([1,2])
  #  fs_parser.set_items.should == [1,2]
  #end
end