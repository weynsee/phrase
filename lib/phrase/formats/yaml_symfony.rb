# -*- encoding : utf-8 -*-

class Phrase::Formats::YamlSymfony < Phrase::Formats::Base
  def self.filename_for_locale(locale)
    "phrase.#{locale.name}.yml"
  end
  
  def self.locale_aware?
    false
  end
end
