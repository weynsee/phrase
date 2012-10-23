require 'spec_helper'

describe Phrase::Tool::Formats::Base do
  let(:the_current_directory) { "./" }
  let(:the_locale_name) { "fooish" }
  let(:the_locale) { Phrase::Tool::Locale.new(name: the_locale_name) }
  
  describe "#self.directory_for_locale" do
    it "should return the path to the current dir" do
      Phrase::Tool::Formats::Base.directory_for_locale(the_locale).should eql(the_current_directory)
    end
  end
  
  describe "#self.filename_for_locale" do
    it "should raise an error" do
      lambda {
        Phrase::Tool::Formats::Base.filename_for_locale("fooish")
      }.should raise_error(/not implemented/)
    end
  end
end