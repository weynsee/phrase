# -*- encoding : utf-8 -*-

module Phrase
  module Formats
    class Strings < Phrase::Formats::Base
      def self.directory_for_locale(locale)
        name = locale.code || locale.name
        "#{formatted(name)}.lproj"
      end

      def self.filename_for_locale(locale)
        "Localizable.strings"
      end

      def self.target_directory
        "./"
      end

      def self.extract_locale_name_from_file_path(file_path)
        file_path.scan(/\/([a-zA-Z\-_]*).lproj\//i).first.try(:first)
      end

      def self.locale_aware?
        true
      end

      # These strings should conform to the same lproj filenames as XCode autogenerates
      # See complete list here http://www.ibabbleon.com/iOS-Language-Codes-ISO-639.html
      def self.formatted(name)
        return name unless name.include?("-")
        parts = name.split("-")
        if parts.first.downcase.include?("zh")
          "#{parts.first.downcase}-#{parts.last.capitalize}"
        else
          "#{parts.first}-#{parts.last.upcase}"
        end
      end
      private_class_method :formatted

      def self.extensions
        [:strings]
      end
    end
  end
end
