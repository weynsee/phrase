# -*- encoding : utf-8 -*-

class Phrase::Tool::Commands::Pull < Phrase::Tool::Commands::Base
  
  ALLOWED_DOWNLOAD_FORMATS = %w(yml po xml strings json resx ts qph ini plist properties xlf)
  DEFAULT_DOWNLOAD_FORMAT = "yml"
  DEFAULT_TARGET_FOLDER = "phrase/locales/"
  
  def initialize(options, args)
    super(options, args)
    require_auth_token!
    
    @locale = @args[1]
    @format = @options.get(:format) || DEFAULT_DOWNLOAD_FORMAT
    @target = @options.get(:target) || DEFAULT_TARGET_FOLDER
  end
  
  def execute!
    (print_error("Invalid format: #{@format}") and exit_command) unless format_valid?(@format)
    locales = (@locale and @locale.strip != '') ? [@locale] : fetch_locales
    locales.each do |locale_name|
      print_message "Downloading phrase.#{locale_name}.#{@format}..."
      fetch_translations_for_locale(locale_name, @format)
    end
  end
  
private
  
  def fetch_translations_for_locale(locale_name, format)
    begin
      content = api_client.download_translations_for_locale(locale_name, format)
      print_message "OK"
      store_content_in_locale_file(locale_name, content)
    rescue Exception => e
      print_error "Failed"
      print_server_error(e.message)
    end
  end
  
  def store_content_in_locale_file(locale_name, content)
    directory = @target
    directory << "/" unless directory.end_with?("/")
    
    begin
      FileUtils.mkpath(directory)
      filename = ""
      File.open("#{directory}phrase.#{locale_name}.#{@format}", "w") do |file|
        file.write(content)
      end
    rescue
      print_error("Cannot write file to target folder (#{directory})")
      exit(101)
    end
  end
  
  def fetch_locales
    begin
      locales = api_client.fetch_locales
      print_message "Fetched all locales"
      locales
    rescue Exception => e  
      print_error "Could not fetch locales from server"
      print_server_error e.message
      exit_command
    end
  end
  
  def format_valid?(format)
    ALLOWED_DOWNLOAD_FORMATS.include?(format)
  end
end