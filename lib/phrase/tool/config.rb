# -*- encoding : utf-8 -*-

require 'json'

class Phrase::Tool::Config
  def initialize
    if File.exist?(".phrase")
      begin
        contents = File.read(".phrase")
        @config = JSON.parse(contents)
      rescue JSON::ParserError => err
        $stderr.puts "Could not parse config file: #{err}"
      end
    end
  end
  
  def secret
    config["secret"]
  end

  def secret=(new_secret)
    config["secret"] = new_secret
    save_config!
  end
  
private  
  def config
    @config ||= {}
  end

  def save_config!
    File.open(".phrase", "w+") do |file|
      file.write(JSON.pretty_generate(config))
    end
  end
end