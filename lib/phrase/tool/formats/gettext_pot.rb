# -*- encoding : utf-8 -*-

class Phrase::Tool::Formats::GettextPot < Phrase::Tool::Formats::Base
  def self.filename_for_locale(locale)
    "phrase.pot"
  end

  def self.locale_aware?
    false
  end
end