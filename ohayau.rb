#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "yaml"
require "twitter"

y_config = YAML.load_file("/Users/iNut/ohayau/ohayauconfig.yaml")

Twitter.configure do |config|
	config.consumer_key = y_config["twitter"]["consumer_key"]
	config.consumer_secret = y_config["twitter"]["consumer_secret"]
	config.oauth_token = y_config["twitter"]["oauth_token"]
	config.oauth_token_secret = y_config["twitter"]["oauth_token_secret"]
end

tw = Twitter::Client.new

if ARGV[0] == "-p"
	tw.update(ARGV[1])

elsif ARGV[0] == "--ohayau"
	ohayaubullet = open("/Users/iNut/ohayau/ohayau.txt").readlines.sample
	tw.update(ohayaubullet)

elsif ARGV[0] == "--beer"
	beer = "#びゐる"
	space = ""
	rand(17).times do
		space += "　"
		tw.update("#{beer}#{space}")
	end
end
