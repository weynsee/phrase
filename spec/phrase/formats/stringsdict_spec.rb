require 'spec_helper'

describe Phrase::Formats::Stringsdict do
  let(:the_prefix) { "phrase" }
  let(:the_locale_name) { "fooish" }
  let(:the_locale) { Phrase::Tool::Locale.new(name: the_locale_name, code: the_locale_code) }
  let(:the_extension) { ".stringsdict" }
  let(:the_locale_code) { "fooish-FOOISH" }

  describe "#self.directory_for_locale" do
    subject { Phrase::Formats::Stringsdict.directory_for_locale(the_locale) }

    context "locale code is set" do
      let(:the_locale_code) { "fooish-foo" }

      it { should == "fooish-FOO.lproj" }
    end

    context "locale code is not set" do
      let(:the_locale_code) { nil }

      it { should == "fooish.lproj" }
    end
  end

  describe "#self.filename_for_locale" do
    subject { Phrase::Formats::Stringsdict.filename_for_locale(the_locale) }

    it { should == "Localizable.stringsdict" }
  end

  describe "#self.extract_locale_name_from_file_path(file_path)" do
    subject { Phrase::Formats::Stringsdict.extract_locale_name_from_file_path(file_path) }

    context "path contains a valid locale" do
      let(:file_path) { "/foo/fr_FR.lproj/Localizable.stringsdict" }

      it { should eql("fr_FR") }
    end

    context "path does not contain a valid locale" do
      let(:file_path) { "/foo/bar/Localizable.stringsdict" }

      it { should be_nil }
    end
  end

  describe "#self.formatted" do
    subject { Phrase::Formats::Stringsdict.send(:formatted, name) }

    context "name contains -" do
      let(:name) { "foo-bar" }

      it { should eql "foo-BAR"}
    end

    context "name does not contain -" do
      let(:name) { "foo" }

      it { should eql "foo" }
    end

    context "name is regional Chinese" do
      let(:name) { "zh-Hans" }

      it { should eql "zh-Hans"}
    end
  end

  describe "#self.locale_aware?" do
    subject { Phrase::Formats::Stringsdict.locale_aware? }

    it { should be_true }
  end
end
