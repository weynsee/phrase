require 'spec_helper'

describe Phrase::Formats::Xml do
  let(:the_prefix) { "phrase" }
  let(:the_locale_name) { "fooish" }
  let(:the_locale_code) { "foo-ish" }
  let(:is_default) { false }
  let(:the_locale) { Phrase::Tool::Locale.new(name: the_locale_name, code: the_locale_code, is_default: is_default) }
  let(:the_extension) { ".xml" }

  describe "#self.directory_for_locale" do
    subject { Phrase::Formats::Xml.directory_for_locale(the_locale) }

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
    subject { Phrase::Formats::Xml.filename_for_locale(the_locale) }

    it { should eql "strings.xml" }
  end

  describe "#self.extract_locale_name_from_file_path(file_path)" do
    subject { Phrase::Formats::Xml.extract_locale_name_from_file_path(file_path) }

    before(:each) do
      Phrase::Formats::Xml.stub(:default_locale_name).and_return("default-locale")
    end

    context "path contains /values/ (which represents the default locale)" do
      let(:file_path) { "/foo/values/strings.xml" }

      it { should eql("default-locale") }
    end

    context "path contains a valid locale" do
      let(:file_path) { "/foo/values-fr/strings.xml" }

      it { should eql("fr") }
    end

    context "path contains a valid, full locale" do
      let(:file_path) { "/foo/values-de-DE/strings.xml" }

      it { should eql("de-DE") }
    end

    context "path contains a valid locale with region" do
      let(:file_path) { "/foo/values-pt-rBR/strings.xml" }

      it { should eql("pt-BR") }
    end

    context "path does not contain a valid locale" do
      let(:file_path) { "/foo/bar/strings.xml" }

      it { should be_nil }
    end
  end

  describe "#self.formatted(name)" do
    subject { Phrase::Formats::Xml.send(:formatted, name) }

    context "name does not contain -" do
      let(:name) { "foo" }

      it { should eql "foo" }
    end

    context "name contains -" do
      let(:name) { "foo-bar" }

      it { should eql "foo-rBAR"}
    end
  end

  describe "#self.locale_aware?" do
    subject { Phrase::Formats::Xml.locale_aware? }

    it { should be_true }
  end
end
