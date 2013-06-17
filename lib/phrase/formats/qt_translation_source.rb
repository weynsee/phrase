# -*- encoding : utf-8 -*-

class Phrase::Formats::QtTranslationSource < Phrase::Formats::Base
  def self.filename_for_locale(locale)
    "phrase.#{locale.name}.ts"
  end
  
  def self.locale_aware?
    true
  end
end
