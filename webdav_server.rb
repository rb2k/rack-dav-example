#!/usr/bin/env ruby
require 'rubygems'
require 'rack'
require 'rack/ssl' #rack-ssl
require 'dav4rack'
require 'rpam'    #rpam-ruby19
require 'openssl'
require 'thin'


app = Rack::Builder.new do
	use Rack::SSL
	use Rack::Auth::Basic do |username, password| 
		Rpam.auth(username, password)
	end

	run DAV4Rack::Handler.new(:root => ARGV[0] || '.')
end.to_app

@server = Thin::Server.new('0.0.0.0', 4433, {}, app)
@server.ssl = true
@server.ssl_options = {:private_key_file => 'server.key', :cert_chain_file => 'server.crt'}
@server.start