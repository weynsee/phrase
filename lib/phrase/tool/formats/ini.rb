# -*- encoding : utf-8 -*-

class Phrase::Tool::Formats::Ini < Phrase::Tool::Formats::Base
  def self.store_path_for_locale(locale_name)
    "phrase.#{locale_name}.ini"
  end
end