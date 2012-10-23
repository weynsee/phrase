# -*- encoding : utf-8 -*-

class Phrase::Tool::Formats::Base
  def self.directory_for_locale(locale_name)
    "./"
  end
  
  def self.filename_for_locale(locale_name)
    raise "not implemented"
  end
end