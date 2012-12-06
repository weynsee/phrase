# -*- encoding : utf-8 -*-

class Phrase::Tool::Formats::Plist < Phrase::Tool::Formats::Base
  def self.filename_for_locale(locale)
    "phrase.#{locale.name}.plist"
  end
  
  def self.locale_aware?
    true
  end
end
