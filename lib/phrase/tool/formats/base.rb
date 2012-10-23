# -*- encoding : utf-8 -*-

class Phrase::Tool::Formats::Base
  def self.directory_for_locale(locale)
    "./"
  end
  
  def self.filename_for_locale(locale)
    raise "not implemented"
  end
  
  def self.extract_locale_name_from_file_path(file_path)
    nil
  end
end