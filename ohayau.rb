# -*- coding: utf-8 -*-

require "yaml"
require "twitter"
require "ap"

def randomize(neta)
  neta.scan(/./).shuffle.join
end

if __FILE__ == $0
  current = File.expand_path(File.dirname(__FILE__))
  y_conf = YAML.load_file("#{current}/ohayauconfig.yaml")
  tw_conf = y_conf[:twitter]
  
  Twitter.configure do |config|
    config.consumer_key = tw_conf[:consumer_key]
    config.consumer_secret = tw_conf[:consumer_secret]
    config.oauth_token = tw_conf[:oauth_token]
    config.oauth_token_secret = tw_conf[:oauth_token_secret]
  end
  
  tw = Twitter::Client.new
  arg = ARGV.first
  
  case
  when arg == "--post"
    text = ARGV[1]
    tw.update(text)

  when arg == "--beer"
    beer = y_config[:beer]
    ws = ""
    rand(17).times do
      text = beer + ws
      tw.update(text)
      ws += y_conf[:whitespace]
    end
    
  when arg == "--ohayau"
    ws = ""
    begin
      neta = y_conf[:ohayau].sample
      text = neta + ws
      tw.update(text)
    rescue
      ws += y_conf[:whitespace]
      retry
    end
    
  when arg == "--randomize"
    neta = ARGV[1]
    text = randomize(neta)
    tw.update(text)
  end
end
