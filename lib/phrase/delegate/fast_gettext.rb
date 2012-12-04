# -*- encoding : utf-8 -*-

require 'phrase/delegate'

class Phrase::Delegate::FastGettext < Phrase::Delegate::Base
  def initialize(key)
    @display_key = key
  end
end