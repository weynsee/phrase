# -*- encoding : utf-8 -*-

module I18n
  class << self
    def translate_with_phrase(*args)
      Phrase.backend.translate(*args)
    end
    alias_method_chain :translate, :phrase
    alias_method :t, :translate
  end
end if defined?(I18n)
