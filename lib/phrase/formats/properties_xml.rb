# -*- encoding : utf-8 -*-

class Phrase::Formats::PropertiesXml < Phrase::Formats::Base
  def self.filename_for_locale(locale)
    "phrase.#{locale.name}.xml"
  end
  
  def self.locale_aware?
    false
  end
end
