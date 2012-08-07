class TagValidator
  
  FORMAT = /\A[a-zA-Z0-9_-]+\z/
  
  def self.valid?(tag_name)
    (tag_name.to_s =~ FORMAT)
  end
end