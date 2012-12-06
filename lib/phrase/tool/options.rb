# -*- encoding : utf-8 -*-

require File.expand_path('../options_factory', __FILE__)

class Phrase::Tool::Options
  def initialize(args, command="")
    @command = command
    # specify all possible arguments here
    @data = {
      default: {
        version: false,
        help: false
      },
      init: {
        secret: "",
        default_locale: "en",
        domain: "phrase",
        default_target: nil,
        format: nil,
        locale_filename: nil,
        locale_directory: nil,
        target_directory: nil 
      },
      push: {
        tags: [],
        recursive: false,
        locale: nil
      },
      pull: {
        format: 'yml',
        target: nil
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
    OptionsFactory.options_for(command_name, @data)
  end
  
  def command_name
    @command_name ||= (@command.present? and @data.has_key?(@command.to_sym)) ? @command.to_sym : :default
  end
end
