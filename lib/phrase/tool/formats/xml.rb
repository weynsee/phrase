# -*- encoding : utf-8 -*-

class Phrase::Tool::Formats::Xml < Phrase::Tool::Formats::Base
  def self.directory_for_locale(locale)
    if locale.default?
      "values" 
    else
      name = locale.code || locale.name
      "values-#{formatted(name)}"
    end
  end
  
  def self.filename_for_locale(locale)
    "strings.xml"
  end
  
  def self.extract_locale_name_from_file_path(file_path)
    return default_locale_name if file_path.scan(/\/values\/strings.xml/i).first
    locale_part = file_path.scan(/\/values-([a-zA-Z\-_]*)\/strings.xml/i).first.try(:first)
    if locale_part and locale_part.include?("-r")
      "#{locale_part.split("-r").first}-#{locale_part.split("-r").last}"
    else
      locale_part
    end
  end
  
  def self.default_locale_name
    Phrase::Tool::Locale.find_default_locale.try(:name)
  end
  private_class_method :default_locale_name
  
  def self.formatted(name)
    return name unless name.include?("-")
    parts = name.split("-")
    "#{parts.first}-r#{parts.last.upcase}"
  end
  private_class_method :formatted
end