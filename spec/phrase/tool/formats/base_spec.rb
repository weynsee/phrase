require 'spec_helper'

describe Phrase::Tool::Formats::Base do
  describe "#self.store_path_for_locale" do
    it "should raise an error" do
      lambda {
        Phrase::Tool::Formats::Base.store_path_for_locale("foo")
      }.should raise_error(/not implemented/)
    end
  end
end