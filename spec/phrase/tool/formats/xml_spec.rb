require 'spec_helper'

describe Phrase::Tool::Formats::Xml do
  let(:the_prefix) { "phrase" }
  let(:the_locale) { "fooish" }
  let(:the_extension) { ".xml" }
  
  describe "#self.directory_for_locale" do
    it "should return the path to the current dir" do
      Phrase::Tool::Formats::Xml.directory_for_locale(the_locale).should eql("values-#{the_locale}")
    end
  end
  
  describe "#self.filename_for_locale" do
    subject { Phrase::Tool::Formats::Xml.filename_for_locale(the_locale) }
    
    it { should_not include the_prefix }
    it { should_not include the_locale }
    it { should start_with "strings" }
    it { should end_with the_extension }
  end
end