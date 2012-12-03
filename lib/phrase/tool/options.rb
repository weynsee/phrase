# -*- encoding : utf-8 -*-

require File.expand_path('../option_factory', __FILE__)

class Phrase::Tool::Options
  def initialize(args, command="")
    @command = command
    @data = {
      default: {
        version: false,
        help: false
      },
      init: {
        secret: "",
        default_locale: "en"
      },
      push: {
        tags: [],
        recursive: false,
        locale: nil
      },
      pull: {
        format: "yml",
        target: "./phrase/locales/"
      }
    }
    options.parse!(args)
  end
  
  def get(name)
    return @data.fetch(command_name).fetch(name.to_sym)
  rescue => e
    $stderr.puts "Invalid or missing option \"#{name}\" for command \"#{command_name}\""
  end
  
private
  
  def options
    OptionFactory.options_for(command_name, @data)
  end
  
  def command_name
    @command_name ||= (@command.present? and @data.has_key?(@command.to_sym)) ? @command.to_sym : :default
  end
end
