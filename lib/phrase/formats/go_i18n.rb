# -*- encoding : utf-8 -*-

module Phrase
  module Formats
    class GoI18n < Phrase::Formats::Base
      def self.filename_for_locale(locale)
        "#{locale.name}.all.json"
      end

      def self.locale_aware?
        false
      end

      def self.extensions
        [:json]
      end

      def self.target_directory
        'locales/'
      end
    end
  end
end
