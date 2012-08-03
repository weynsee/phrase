# -*- encoding : utf-8 -*-

require 'phrase/api'

class Phrase::Delegate < String
  attr_accessor :key, :display_key, :options, :api_client, :fallback_keys
  
  def initialize(key, options={})
    @display_key = @key = key
    @options = options
    @fallback_keys = []
    
    extract_fallback_keys
    identify_key_to_display if @fallback_keys.any?
    super(decorated_key_name)
  end
  
  def to_s
    "#{decorated_key_name}"
  end
  
  def method_missing(*args, &block)
    if @key.respond_to?(args.first) 
      to_s.send(*args)
    else
      data = translation_or_subkeys
      if data.is_a?(String)
        to_s
      elsif data.respond_to?(args.first)
        data.send(*args, &block)
      else
        log "You are trying to execute the method ##{args.first} on a translation key which is not supported. Please make sure you treat your translations as strings only."
        nil
      end
    end
  end
  
private
  def identify_key_to_display
    key_names = [@key] | @fallback_keys
    available_key_names = find_keys_from_service(key_names).map { |key| key["name"] }
    @display_key = @key
    key_names.each do |item|
      if available_key_names.include?(item)
        @display_key = item
        break
      end
    end
  end
  
  def find_keys_from_service(key_names)
    api_client.find_keys_by_name(key_names)
  end
  
  def extract_fallback_keys
    fallback_items = []
    if @options.has_key?(:default)
      if @options[:default].kind_of?(Array)
        fallback_items = @options[:default]
      else
        fallback_items << @options[:default]
      end
    end
    fallback_items.each do |item|
      process_fallback_item(item)
    end
  end
  
  def process_fallback_item(item)
    if item.kind_of?(Symbol)
      @fallback_keys << item.to_s
      if @key == "helpers.label.#{item.to_s}" # http://apidock.com/rails/v3.1.0/ActionView/Helpers/FormHelper/label
        @fallback_keys << "activerecord.attributes.#{item.to_s}"
      end
    end
  end

  def decorated_key_name
    "#{Phrase.prefix}phrase_#{@display_key}#{Phrase.suffix}"
  end
  
  def translation_or_subkeys
    begin
      api_client.translate(@key)
    rescue Exception => e
      log "Server Error: #{e.message}"
    end
  end
  
  def api_client
    @api_client ||= Phrase::Api::Client.new(Phrase.auth_token)
  end
  
  def log(message)
    message = "phrase: #{message}"
    if defined?(Rails)
      Rails.logger.warn(message)
    else
      $stderr.puts message
    end
  end
end
