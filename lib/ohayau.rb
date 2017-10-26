# -*- coding: utf-8 -*-

require "yaml"
require "twitter"
require "open-uri"

def randomize(neta)
  neta.scan(/./).shuffle.join
end

if __FILE__ == $0
  current_dir = File.expand_path(File.dirname(__FILE__))
  y_conf = YAML.load_file("#{current_dir}/../config/ohayauconfig.yaml")
  tw_conf = y_conf[:twitter]
  
  tw = Twitter::REST::Client.new do |config|
    config.consumer_key = tw_conf[:consumer_key]
    config.consumer_secret = tw_conf[:consumer_secret]
    config.access_token = tw_conf[:oauth_token]
    config.access_token_secret = tw_conf[:oauth_token_secret]
  end

  us = Twitter::Streaming::Client.new do |config|
    config.consumer_key = tw_conf[:consumer_key]
    config.consumer_secret = tw_conf[:consumer_secret]
    config.access_token = tw_conf[:oauth_token]
    config.access_token_secret = tw_conf[:oauth_token_secret]
  end
  
  arg = ARGV.first
  
  case arg
  when "--post"
    text = ARGV[1]
    tw.update(text)

  when "--beer"
    beer = y_conf[:beer]
    ws = ""
    rand(23).times do
      text = beer + ws
      tw.update(text)
      ws += y_conf[:whitespace]
    end

  when "--rain-of-beer"
    beer = y_conf[:beer]
    rand(23).times do
      num_of_beer = rand(14)
      text = beer * num_of_beer
      tw.update(text)
    end
    
    ws = ""
    rand(23).times do
      text = beer + ws
      tw.update(text)
      ws += y_conf[:whitespace]
    end
    
  when "--ohayau"
    ws = ""
    begin
      neta = y_conf[:ohayau].sample
      text = neta + ws
      tw.update(text)
    rescue
      ws += y_conf[:whitespace]
      retry
    end
    
  when "--randomize"
    neta = ARGV[1]
    text = randomize(neta)
    tw.update(text)
    
  when "--repeat"
    count = ARGV[1]
    neta = ARGV[2]
    ws = ""
    count.to_i.times do
      text = neta + ws
      tw.update(text)
      ws += y_conf[:whitespace]
    end

  when "--us-test"
    us.sample do |status|
      unless status["friends"]
        ap status.user.name
        ap status.text
      end
    end

  when "--server-monitor"
    ip = ARGV[1]
    loop do
      status = system("ping -c 1 #{ip} > /dev/null")
      if status
        tw.update("@iNut りなちゃん起きたよ！")
        break
      else
        puts "she's still sleeping.. #{Time.now}"
        sleep 10
      end
    end
  
  when "--dbclswebsite-monitor"
    url = "http://dbcls.rois.ac.jp"
    page = open(url).read
    #tw.update("@iNut 死んだ") if page !~ /<title>Database/
  end
end
