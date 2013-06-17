# -*- encoding : utf-8 -*-

class Phrase::Formats::Ini < Phrase::Formats::Base
  def self.filename_for_locale(locale)
    "phrase.#{locale.name}.ini"
  end
  
  def self.locale_aware?
    true
  end
end
