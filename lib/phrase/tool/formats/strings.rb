# -*- encoding : utf-8 -*-

class Phrase::Tool::Formats::Strings < Phrase::Tool::Formats::Base
  def self.directory_for_locale(locale)
    name = locale.code || locale.name
    "#{formatted(name)}.lproj"
  end
  
  def self.filename_for_locale(locale)
    "Localizable.strings"
  end
  
  def self.formatted(name)
    return name unless name.include?("-")
    parts = name.split("-")
    "#{parts.first}_#{parts.last.upcase}"
  end
  private_class_method :formatted
end