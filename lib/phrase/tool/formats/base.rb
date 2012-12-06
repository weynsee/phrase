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
  
  def self.default_locale_name
    Phrase::Tool::Locale.find_default_locale.try(:name)
  end
  
  def self.locale_aware?
    false
  end

  def self.target_directory
    "phrase/locales/"
  end
  
  def self.config
    @config ||= get_config
  end

  def self.get_config
    config = Phrase::Tool::Config.new
    config.load
  end
  private_class_method :config
end
