require 'spec_helper'

describe Phrase::Tool::Formats::Strings do
  let(:the_prefix) { "phrase" }
  let(:the_locale_name) { "fooish" }
  let(:the_locale) { Phrase::Tool::Locale.new(name: the_locale_name, code: the_locale_code) }
  let(:the_extension) { ".strings" }
  let(:the_locale_code) { "fooish-FOOISH" }
  
  describe "#self.directory_for_locale" do
    subject { Phrase::Tool::Formats::Strings.directory_for_locale(the_locale) }
    
    context "locale code is set" do
      let(:the_locale_code) { "fooish-foo" }
      
      it { should == "fooish_FOO.lproj" }
    end
    
    context "locale code is not set" do      
      let(:the_locale_code) { nil }
      
      it { should == "fooish.lproj" }
    end
  end
  
  describe "#self.filename_for_locale" do
    subject { Phrase::Tool::Formats::Strings.filename_for_locale(the_locale) }
    
    it { should == "Localizable.strings" }
  end
  
  describe "#self.extract_locale_name_from_file_path(file_path)" do
    subject { Phrase::Tool::Formats::Strings.extract_locale_name_from_file_path(file_path) }
    
    context "path contains a valid locale" do
      let(:file_path) { "/foo/fr_FR.lproj/Localizable.strings" }
      
      it { should eql("fr_FR") }
    end
    
    context "path does not contain a valid locale" do
      let(:file_path) { "/foo/bar/Localizable.strings" }
      
      it { should be_nil }
    end
  end
  
  describe "#self.formatted" do
    subject { Phrase::Tool::Formats::Strings.send(:formatted, name) }
    
    context "name contains -" do
      let(:name) { "foo-bar" }
      
      it { should eql "foo_BAR"}
    end
    
    context "name does not contain -" do
      let(:name) { "foo" }
      
      it { should eql "foo" }
    end
  end
end