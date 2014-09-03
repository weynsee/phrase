# -*- encoding : utf-8 -*-

module Phrase
  module Formats
    class PlayProperties < Phrase::Formats::Base
      def self.filename_for_locale(locale)
        "phrase.messages.#{locale.code}"
      end
      
      def self.renders_locale_as_extension?
        true
      end
    end
  end
end
