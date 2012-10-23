# -*- encoding : utf-8 -*-

class Phrase::Tool::Formats::Yaml < Phrase::Tool::Formats::Base
  def self.filename_for_locale(locale)
    "phrase.#{locale.name}.yml"
  end
end