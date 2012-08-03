# -*- encoding : utf-8 -*-

require 'phrase'
require 'i18n'

if defined? Rails
  class Phrase::Engine < Rails::Engine
    initializer 'phrase' do |app|
      ActionView::Base.send :include, Phrase::ViewHelpers
    end
  end
end