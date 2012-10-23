# -*- encoding : utf-8 -*-

class Phrase::Tool::Formats::Strings < Phrase::Tool::Formats::Base
  def self.directory_for_locale(locale_name)
    "#{locale_name}.lproj"
  end
  
  def self.filename_for_locale(locale_name)
    "Localizable.strings"
  end
end