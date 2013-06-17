# -*- encoding : utf-8 -*-

class Phrase::Formats::Xliff < Phrase::Formats::Base
  def self.filename_for_locale(locale)
    "phrase.#{locale.name}.xlf"
  end
  
  def self.locale_aware?
    true
  end
end
