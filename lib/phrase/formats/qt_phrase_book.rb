# -*- encoding : utf-8 -*-

class Phrase::Formats::QtPhraseBook < Phrase::Formats::Base
  def self.filename_for_locale(locale)
    "phrase.#{locale.name}.qph"
  end
  
  def self.locale_aware?
    true
  end
end
