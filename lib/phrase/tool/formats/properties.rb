# -*- encoding : utf-8 -*-

class Phrase::Tool::Formats::Properties < Phrase::Tool::Formats::Base
  def self.filename_for_locale(locale)
    "phrase.#{locale.name}.properties"
  end
  
  def self.locale_aware?
    true
  end
end