# -*- encoding : utf-8 -*-

class Phrase::Tool::Formats::Resx < Phrase::Tool::Formats::Base
  def self.filename_for_locale(locale)
    "phrase.#{locale.name}.resx"
  end
end