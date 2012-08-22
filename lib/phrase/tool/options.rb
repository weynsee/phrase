# -*- encoding : utf-8 -*-

require 'optparse'

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
        recursive: false
      },
      pull: {
        format: "yml"
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
    case command_name
      when :init
        OptionParser.new do |opts|
          opts.on("--secret=YOUR_AUTH_TOKEN", String, "Your auth token") do |secret|
            @data[command_name][:secret] = secret
          end
          
          opts.on("--default-locale=en", String, "The default locale for your application") do |default_locale|
            @data[command_name][:default_locale] = default_locale
          end
        end
      when :push
        OptionParser.new do |opts|
          opts.on("--tags=foo,bar", Array, "List of tags for phrase push (separated by comma)") do |tags|
            @data[command_name][:tags] = tags
          end
          
          opts.on("-R", "--recursive", "Push files in subfolders as well (recursively)") do |recursive|
            @data[command_name][:recursive] = true
          end
        end
      when :pull
        OptionParser.new do |opts|
          opts.on("--format=yml", String, "Allowed formats: #{Phrase::Tool::ALLOWED_DOWNLOAD_FORMATS.join(", ")}") do |format|
            @data[command_name][:format] = format
          end
        end
      else
        OptionParser.new do |opts|
          opts.on_tail("-v", "--version", "Show version number") do |version|
            @data[:default][:version] = true
          end
          
          opts.on_tail("-h", "--help", "Show help") do |help|
            @data[:default][:help] = true
          end
        end
    end
  end
  
  def command_name
    @command_name ||= (@command.present? and @data.has_key?(@command.to_sym)) ? @command.to_sym : :default
  end
end