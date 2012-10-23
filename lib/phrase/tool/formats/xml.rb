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
  
  def self.formatted(name)
    return name unless name.include?("-")
    parts = name.split("-")
    "#{parts.first}-r#{parts.last.upcase}"
  end
  private_class_method :formatted
end