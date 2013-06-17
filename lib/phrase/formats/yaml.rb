# -*- encoding : utf-8 -*-

class Phrase::Formats::Yaml < Phrase::Formats::Base
  def self.filename_for_locale(locale)
    "phrase.#{locale.name}.yml"
  end
  
  def self.locale_aware?
    true
  end
end
