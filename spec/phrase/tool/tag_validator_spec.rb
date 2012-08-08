require 'spec_helper'

describe Phrase::Tool::TagValidator do
  describe "#self.valid?(tag_name)" do
    context "tag contains special chars" do
      it "should be false" do
        Phrase::Tool::TagValidator.valid?("foo$").should be_false
      end
    end
    
    context "tag contains only letters and numbers" do
      it "should be false" do
        Phrase::Tool::TagValidator.valid?("foo17").should be_true
      end
    end
    
    context "tag contains - or _" do
      it "should be false" do
        Phrase::Tool::TagValidator.valid?("foo_bar-baz").should be_true
      end
    end
  end
end