require 'spec_helper'

describe Phrase::Tool::Formats::Base do
  let(:the_current_directory) { "./" }
  
  describe "#self.directory_for_locale" do
    it "should return the path to the current dir" do
      Phrase::Tool::Formats::Base.directory_for_locale("foo").should eql(the_current_directory)
    end
  end
  
  describe "#self.filename_for_locale" do
    it "should raise an error" do
      lambda {
        Phrase::Tool::Formats::Base.filename_for_locale("foo")
      }.should raise_error(/not implemented/)
    end
  end
end