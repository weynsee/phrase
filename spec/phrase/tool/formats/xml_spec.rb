require 'spec_helper'

describe Phrase::Tool::Formats::Xml do
  let(:the_prefix) { "phrase" }
  let(:the_locale_name) { "fooish" }
  let(:the_locale_code) { "foo-ish" }
  let(:is_default) { false }
  let(:the_locale) { Phrase::Tool::Locale.new(name: the_locale_name, code: the_locale_code, is_default: is_default) }
  let(:the_extension) { ".xml" }
  
  describe "#self.directory_for_locale" do
    subject { Phrase::Tool::Formats::Xml.directory_for_locale(the_locale) }
    
    context "locale is default" do
      let(:is_default) { true }
      
      it { should eql "values" }
    end
    
    context "locale is not default" do
      let(:is_default) { false }
      
      context "locale code is given" do
        let(:the_locale_code) { "foo-ish" }
        
        it { should eql "values-foo-rISH" }
      end

      context "locale code is not given" do
        let(:the_locale_code) { nil }
        
        it { should eql "values-#{the_locale_name}" }
      end
    end
  end
  
  describe "#self.filename_for_locale" do
    subject { Phrase::Tool::Formats::Xml.filename_for_locale(the_locale) }
    
    it { should eql "strings.xml" }
  end
  
  describe "#self.formatted(name)" do
    subject { Phrase::Tool::Formats::Xml.send(:formatted, name) }
    
    context "name does not contain -" do
      let(:name) { "foo" }

      it { should eql "foo" }
    end
    
    context "name contains -" do
      let(:name) { "foo-bar" }
      
      it { should eql "foo-rBAR"}
    end
  end
end