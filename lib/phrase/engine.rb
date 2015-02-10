# -*- encoding : utf-8 -*-

require 'phrase'
require 'i18n'

if defined? Rails
  class Phrase::Engine < Rails::Engine
    initializer 'phrase', :after => :disable_dependency_loading do |app|
      if Phrase.enabled?
        require 'phrase/adapters/i18n'
        require 'phrase/adapters/fast_gettext'
      end

      ActionView::Base.send :include, Phrase::ViewHelpers
    end
  end
end
