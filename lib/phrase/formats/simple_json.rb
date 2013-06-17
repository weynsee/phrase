# -*- encoding : utf-8 -*-

class Phrase::Formats::SimpleJson < Phrase::Formats::Base
  def self.filename_for_locale(locale)
    "phrase.#{locale.name}.json"
  end
  
  def self.locale_aware?
    false
  end
end
