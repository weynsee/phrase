# -*- encoding : utf-8 -*-

class Phrase::Formats::GettextPot < Phrase::Formats::Base
  def self.filename_for_locale(locale)
    "phrase.pot"
  end

  def self.locale_aware?
    false
  end
end
