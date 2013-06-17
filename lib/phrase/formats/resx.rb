# -*- encoding : utf-8 -*-

class Phrase::Formats::Resx < Phrase::Formats::Base
  def self.filename_for_locale(locale)
    "phrase.#{locale.name}.resx"
  end
  
  def self.locale_aware?
    false
  end
end
