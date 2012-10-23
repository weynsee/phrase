# -*- encoding : utf-8 -*-

class Phrase::Tool::Formats::Ini < Phrase::Tool::Formats::Base
  def self.filename_for_locale(locale_name)
    "phrase.#{locale_name}.ini"
  end
end