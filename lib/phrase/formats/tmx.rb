# -*- encoding : utf-8 -*-

class Phrase::Formats::Tmx < Phrase::Formats::Base
  def self.filename_for_locale(locale)
    "phrase.#{locale.name}.tmx"
  end
  
  def self.locale_aware?
    false
  end
end
