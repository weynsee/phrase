# -*- encoding : utf-8 -*-

class Phrase::Tool::Locale
  attr_accessor :id, :name, :code, :is_default
  
  def initialize(attrs={})
    attrs.each do |key,value|
      self.send("#{key}=", value)
    end
  end
  
  def default?
    self.is_default == true
  end
  
  def ==(object)
    object.id == self.id
  end
end