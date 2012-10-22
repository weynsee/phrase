# -*- encoding : utf-8 -*-

module Phrase::Tool::Formats
  autoload :Base, 'phrase/tool/formats/base'
  autoload :Yaml, 'phrase/tool/formats/yaml'
  autoload :Gettext, 'phrase/tool/formats/gettext'
  autoload :Xml, 'phrase/tool/formats/xml'
  autoload :Strings, 'phrase/tool/formats/strings'
  autoload :Xliff, 'phrase/tool/formats/xliff'
  autoload :QtPhraseBook, 'phrase/tool/formats/qt_phrase_book'
  autoload :QtTranslationSource, 'phrase/tool/formats/qt_translation_source'
  autoload :Json, 'phrase/tool/formats/json'
  autoload :Resx, 'phrase/tool/formats/resx'
  autoload :Ini, 'phrase/tool/formats/ini'
  autoload :Properties, 'phrase/tool/formats/properties'
  autoload :Plist, 'phrase/tool/formats/plist'
  
  SUPPORTED_FORMATS = {
    yml: Phrase::Tool::Formats::Yaml,
    po: Phrase::Tool::Formats::Gettext,
    xml: Phrase::Tool::Formats::Xml,
    strings: Phrase::Tool::Formats::Strings,
    xlf: Phrase::Tool::Formats::Xliff,
    qph: Phrase::Tool::Formats::QtPhraseBook,
    ts: Phrase::Tool::Formats::QtTranslationSource,
    json: Phrase::Tool::Formats::Json,
    resx: Phrase::Tool::Formats::Resx,
    ini: Phrase::Tool::Formats::Ini,
    properties: Phrase::Tool::Formats::Properties,
    plist: Phrase::Tool::Formats::Plist
  }
  
  def self.store_path_for_locale_in_format(locale_name, format_name)
    handler = handler_class_for_format(format_name)
    handler.store_path_for_locale(locale_name)
  end
  
  def self.handler_class_for_format(format_name)
    SUPPORTED_FORMATS.fetch(format_name.to_sym)
  end
  private_class_method :handler_class_for_format
end