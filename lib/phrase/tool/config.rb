# -*- encoding : utf-8 -*-

require 'json'

class Phrase::Tool::Config
  def load
    if File.exist?(".phrase")
      begin
        contents = File.read(".phrase")
        @config = JSON.parse(contents)
      rescue JSON::ParserError => err
        $stderr.puts "Could not parse config file: #{err}"
      end
    end
    self
  end
  
  def secret
    config["secret"]
  end

  def secret=(new_secret)
    config["secret"] = new_secret
    save_config!
  end

  def default_locale
    config["default_locale"]
  end

  def default_locale=(new_default_locale)
    config["default_locale"] = new_default_locale
    save_config!
  end

  def domain
    config["domain"] || 'phrase'
  end

  def domain=(new_domain)
    config["domain"] = new_domain
    save_config!
  end

  def format
    config["format"]
  end

  def format=(new_domain)
    config["format"] = new_domain
    save_config!
  end
  
  def target_directory
    config["target_directory"]
  end

  def target_directory=(new_domain)
    config["target_directory"] = new_domain
    save_config!
  end

  def locale_directory
    config["locale_directory"]
  end

  def locale_directory=(new_domain)
    config["locale_directory"] = new_domain
    save_config!
  end

  def locale_filename
    config["locale_filename"]
  end

  def locale_filename=(new_domain)
    config["locale_filename"] = new_domain
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
