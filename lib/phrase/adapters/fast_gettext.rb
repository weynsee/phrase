# -*- encoding : utf-8 -*-

require 'phrase/delegate/fast_gettext'

module FastGettext
  module Translation
    def __with_phrase(key)
      Phrase::Delegate::FastGettext.new(key)
    end
    alias_method_chain :_, :phrase
    
    def n__with_phrase(*keys)
      Phrase::Delegate::FastGettext.new(keys)
    end
    alias_method_chain :n_, :phrase
    
    def s__with_phrase(key, separator=nil)
      Phrase::Delegate::FastGettext.new(key)
    end
    alias_method_chain :s_, :phrase
  end
end if defined? FastGettext::Translation
