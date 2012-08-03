# -*- encoding : utf-8 -*-

require 'active_support/all'

module Phrase
  autoload :Config, 'phrase/config'
  
  CLIENT_VERSION = "0.1"
  API_VERSION = "v1"
  
  class << self
    
    def config
      Thread.current[:phrase_config] ||= Phrase::Config.new
    end
    
    def config=(value)
      Thread.current[:phrase_config] = value
    end
    
    %w(enabled backend prefix suffix auth_token client_version js_host js_use_ssl).each do |method|
      module_eval <<-DELEGATORS, __FILE__, __LINE__ + 1
        def #{method}
          config.#{method}
        end
      DELEGATORS
    
      module_eval <<-DELEGATORS, __FILE__, __LINE__ + 1
        def #{method}=(value)
          config.#{method} = (value)
        end
      DELEGATORS
    end
    
    def enabled?
      enabled
    end
    
    def disabled?
      !enabled
    end
  end
  
  autoload :ViewHelpers, 'phrase/view_helpers'
  
  require 'phrase/engine'
  require 'phrase/backend'
end

module I18n
  class << self
    def translate_with_phrase(*args)
      Phrase.backend.translate(*args)
    end
    alias_method_chain :translate, :phrase
    alias_method :t, :translate
  end
end