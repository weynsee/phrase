# -*- encoding : utf-8 -*-

class Phrase::Tool::Commands::Pull < Phrase::Tool::Commands::Base
  ALLOWED_DOWNLOAD_FORMATS = %w(yml po xml strings json resx ts qph ini plist properties xlf)
  DEFAULT_DOWNLOAD_FORMAT = "yml"
  
  def initialize(options, args)
    super(options, args)
    require_auth_token!
    
    @locale = @args[1]
    
    # TODO: remove DEFAULT_DOWNLOAD_FORMAT when phrase app has been updated
    @format = @options.get(:format) || config.format || DEFAULT_DOWNLOAD_FORMAT
    @target = @options.get(:target)
    @target ||= Phrase::Tool::Formats.target_directory(@format) if format_valid?(@format)
  end
  
  def execute!
    (print_error("Invalid format: #{@format}") and exit_command) unless format_valid?(@format)
    locales_to_download.compact.each do |locale|
      print_message "Downloading #{locale.name}..."
      fetch_translations_for_locale(locale, @format)
    end
  end
  
private
  def fetch_translations_for_locale(locale, format)
    begin
      content = api_client.download_translations_for_locale(locale.name, format)
      store_content_in_locale_file(locale, content)
    rescue Exception => e
      print_error "Failed"
      print_server_error(e.message)
    end
  end
  
  def store_content_in_locale_file(locale, content)
    directory = Phrase::Tool::Formats.directory_for_locale_in_format(locale, @format)
    filename = Phrase::Tool::Formats.filename_for_locale_in_format(locale, @format)
    path = File.join(base_directory, directory)
    target = File.join(path, filename)
    begin
      FileUtils.mkpath(path)
      File.open(target, "w") do |file|
        file.write(content)
      end
      print_message "Saved to #{clean_path target}".green
    rescue
      print_error("Cannot write file to target folder (#{path})")
      exit_command
    end
  end

  def clean_path(str)
    str.gsub("/./", "/")
  end
  
  def fetch_locales
    begin
      Phrase::Tool::Locale.all
    rescue Exception => e
      print_error "Could not fetch locales from server"
      print_server_error e.message
      exit_command
    end
  end
  
  def format_valid?(format)
    format.nil? or ALLOWED_DOWNLOAD_FORMATS.include?(format)
  end
  
  def base_directory
    directory = @target
  end
  
  # TODO: test
  def locales_to_download
    if user_specified_a_locale?
      [specified_locale]
    else
      all_locales
    end
  end
  
  # TODO: test
  def specified_locale
    locale = all_locales.select { |locale| locale.name == @locale }.first
    (print_error("Locale #{@locale} does not exist") and exit_command) if locale.nil?
    locale
  end
  
  # TODO: test
  def all_locales
    @all_locales_from_server ||= fetch_locales
  end
  
  # TODO: test
  def user_specified_a_locale?
    @locale and @locale.strip != ''
  end
end
