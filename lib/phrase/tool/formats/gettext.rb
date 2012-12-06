# -*- encoding : utf-8 -*-

class Phrase::Tool::Formats::Gettext < Phrase::Tool::Formats::Base
  def self.filename_for_locale(locale)
    "phrase.#{locale.name}.po"
  end
  
  def self.locale_aware?
    true
  end
end