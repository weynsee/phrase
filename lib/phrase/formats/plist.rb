# -*- encoding : utf-8 -*-

class Phrase::Formats::Plist < Phrase::Formats::Base
  def self.filename_for_locale(locale)
    "phrase.#{locale.name}.plist"
  end
  
  def self.locale_aware?
    true
  end
end
