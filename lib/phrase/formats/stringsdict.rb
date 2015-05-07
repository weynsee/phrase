# -*- encoding : utf-8 -*-

module Phrase
  module Formats
    class Stringsdict < Phrase::Formats::Strings
      def self.filename_for_locale(locale)
        "Localizable.stringsdict"
      end

      def self.extensions
        [:stringsdict]
      end
    end
  end
end
