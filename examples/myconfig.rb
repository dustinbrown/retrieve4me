#!/usr/bin/env ruby
#config file

class MyConfig
  attr_accessor :attrs

  def initialize
    @attrs = {
      :download_path  => '/tmp/changeme',
			:ftp_password   => 'fake_ftp_pw',
			:ftp_url        => 'sftp://localhost:22',
      :host_url       => 'http://localhost:1234/changeme'
      :password       => 'fake_pw',
      :username       => 'fake_user',
    }
  end

end
