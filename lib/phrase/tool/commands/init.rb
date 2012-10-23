# -*- encoding : utf-8 -*-

class Phrase::Tool::Commands::Init < Phrase::Tool::Commands::Base
  def initialize(options, args)
    super(options, args)
  end
  
  def execute!
    secret = options.get(:secret)
    if secret.present?
      config.secret = secret
      print_message "Wrote secret to config file .phrase"
      default_locale_name = options.get(:default_locale)    
      create_locale(default_locale_name)
      make_locale_default(default_locale_name)
    else
      print_auth_token_error
      exit_command
    end
  end
  
private
  
  def create_locale(name)
    begin
      api_client.create_locale(name)
      print_message "Created locale \"#{name}\""
    rescue Exception => e
      print_message "Notice: Locale \"#{name}\" could not be created (maybe it already exists)"
    end
  end
  
  def make_locale_default(name)
    begin
      api_client.make_locale_default(name)
      print_message "Locale \"#{name}\" is now the default locale"
    rescue Exception => e
      print_message "Notice: Locale \"#{name}\" could not be made the default locale"
      print_server_error(e.message)
    end
  end
  
  def print_auth_token_error
    print_error "No auth token was given"
    print_error "Please provide the --secret=YOUR_SECRET parameter."
  end
end