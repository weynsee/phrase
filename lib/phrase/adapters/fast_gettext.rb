# -*- encoding : utf-8 -*-

require 'phrase/delegate/fast_gettext'

module FastGettext
  module Translation
    def __with_phrase(*args)
      Phrase::Delegate::FastGettext.new(:_, *args)
    end
    alias_method_chain :_, :phrase
    
    def n__with_phrase(*args)
      Phrase::Delegate::FastGettext.new(:n_, *args)
    end
    alias_method_chain :n_, :phrase
    
    def s__with_phrase(*args)
      Phrase::Delegate::FastGettext.new(:s_, *args)
    end
    alias_method_chain :s_, :phrase
  end
end if defined? FastGettext::Translation
