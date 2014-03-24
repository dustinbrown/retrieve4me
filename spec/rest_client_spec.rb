#!/usr/bin/env ruby
#require_relative '../myconfig.rb'
require_relative '../lib/rest_client.rb'
require 'webmock/rspec'

RSpec.configure do |config|
  config.mock_framework = :mocha
end

describe 'rest_client' do
  let(:config) { {
      :username       => 'test',
      :password       => 'password',
      :download_path  => '/tmp',
      :protocol       => 'http://',
      :url_no_prefix  => 'localhost:1234/fake',
      :host_url       => 'http://localhost:1234/fake'
    } }
  let(:rest_client) { Rest_Client.new(config) }
  let(:full_url) { "#{config[:protocol]}#{config[:username]}:#{config[:password]}@#{config[:url_no_prefix]}" }

  
  it 'should return Rest_Client as class type' do
  #it 'get_items should return array of files' do
    rest_client.class.should == Rest_Client
  end
    
  it 'connect should return true' do
    stub_request(:get, full_url).to_return(:status => 200)
    rest_client.fetch.should == true
  end
  
  #it "should return sinatra appears offline if it can't reach the host_url" do
  #  stub_request(:any, 'http://')
  #  expect { rest_client.fetch }.to raise_error 'Error'
  #end
 #  it 'set_items return array' do
 #   fs_parser.stubs(:get_items_in_path).returns([1,2])
 #   fs_parser.set_items.should == [1,2]
 #  end
end