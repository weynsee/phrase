# -*- encoding : utf-8 -*-

class Phrase::Tool::Formats::QtTranslationSource < Phrase::Tool::Formats::Base
  def self.filename_for_locale(locale)
    "phrase.#{locale.name}.ts"
  end
  
  def self.locale_aware?
    true
  end
end