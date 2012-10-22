# -*- encoding : utf-8 -*-

class Phrase::Tool::Formats::Properties < Phrase::Tool::Formats::Base
  def self.store_path_for_locale(locale_name)
    "phrase.#{locale_name}.properties"
  end
end