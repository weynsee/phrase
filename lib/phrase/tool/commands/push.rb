# -*- encoding : utf-8 -*-

class Phrase::Tool::Commands::Push < Phrase::Tool::Commands::Base
  ALLOWED_FILE_TYPES = %w(yml pot po xml strings json resx ts qph ini plist properties xlf)
  FORMATS_CONTAINING_LOCALE = %q(po yml qph ts xlf)
  RAILS_DEFAULT_FOLDER = "./config/locales/"
  
  def initialize(options, args)
    super(options, args)
    require_auth_token!
    
    @file_name = @args[1]
    @locale = @options.get(:locale)
    @tags = @options.get(:tags)
    @recursive = @options.get(:recursive)
  end
  
  def execute!
    unless @tags.empty? or valid_tags_are_given?(@tags)
      print_error "Invalid tags: Only letters, numbers, underscores and dashes are allowed"
      exit_command
    end
    
    files = choose_files_to_upload
    if files.empty?
      print_message "Could not find any files to upload".light_red
      exit_command
    else
      upload_files(files)
    end
  end
  
private
  def choose_files_to_upload
    if @file_name.blank?
      if rails_default_locale_folder_available?
        @file_name = RAILS_DEFAULT_FOLDER
        print_message "No file or directory specified, using #{RAILS_DEFAULT_FOLDER}"
      else 
        print_error "Need either a file or directory:"
        print_error "phrase push FILE"
        print_error "phrase push DIRECTORY"
        exit_command
      end
    end

    unless File.exist?(@file_name)
      print_error "The file #{@file_name} could not be found."
      exit_command
    end

    if File.directory?(@file_name)
      pattern = @recursive ? "#{File.expand_path(@file_name)}/**/*" : "#{File.expand_path(@file_name)}/**"
      files = Dir.glob(pattern)
    else
      files = [@file_name]
    end
  end

  def upload_files(files)
    files.each { |file| upload_file(file) }
  end
  
  def upload_file(file)
    valid = true
    
    if File.directory?(file)
      valid = false
    end
    
    unless file_valid?(file)
      valid = false
      print_error "Notice: Could not upload #{file} (type not supported)"
    end
    
    if valid
      begin
        tagged = " (tagged: #{@tags.join(", ")})" if @tags.size > 0
        print_message "Uploading #{file}#{tagged}..."
        api_client.upload(file, File.read(file), @tags, @locale)
        print_message "OK".green
      rescue Exception => e
        print_message "Failed"
        print_server_error(e.message, file)
      end
    end
  end
  
  def file_valid?(filepath)
    extension = filepath.split('.').last
    ALLOWED_FILE_TYPES.include?(extension)
  end
  
  def valid_tags_are_given?(tags)
    tags.all? { |tag| Phrase::Tool::TagValidator.valid?(tag) }
  end
  
  def rails_default_locale_folder_available?
    File.exist?(RAILS_DEFAULT_FOLDER) && File.directory?(RAILS_DEFAULT_FOLDER)
  end
end