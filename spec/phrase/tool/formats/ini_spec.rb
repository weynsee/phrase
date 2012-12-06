require 'spec_helper'

describe Phrase::Tool::Formats::Ini do
  let(:the_current_directory) { "./" }
  let(:the_prefix) { "phrase" }
  let(:the_locale_name) { "fooish" }
  let(:the_locale) { Phrase::Tool::Locale.new(name: the_locale_name) }
  let(:the_extension) { ".ini" }
  
  describe "#self.directory_for_locale" do
    it "should return the path to the current dir" do
      Phrase::Tool::Formats::Ini.directory_for_locale(the_locale).should eql(the_current_directory)
    end
  end
  
  describe "#self.filename_for_locale" do
    subject { Phrase::Tool::Formats::Ini.filename_for_locale(the_locale) }
    
    it { should include the_prefix }
    it { should include the_locale_name }
    it { should end_with the_extension }
  end
  
  describe "#self.locale_aware?" do
    subject { Phrase::Tool::Formats::Ini.locale_aware? }
    
    it { should be_true }
  end
end