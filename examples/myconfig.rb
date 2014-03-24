#!/usr/bin/env ruby
#config file

class MyConfig
  attr_accessor :attrs

  def initialize
    @attrs = {
      :username       => 'fake_user',
      :password       => 'fake_pw',
      :download_path  => '/tmp/changeme',
      :host_url       => 'http://localhost:1234/changeme'
    }
  end

end
