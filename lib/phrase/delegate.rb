# -*- encoding : utf-8 -*-

module Phrase::Delegate
  class Base < String
    def to_s
      "#{decorated_key_name}"
    end
    
  protected
    def decorated_key_name
      "#{Phrase.prefix}phrase_#{@display_key}#{Phrase.suffix}"
    end
  end
end