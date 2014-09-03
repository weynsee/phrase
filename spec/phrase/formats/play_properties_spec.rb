require 'spec_helper'

describe Phrase::Formats::PlayProperties do
  let(:the_current_directory) { "./" }
  let(:the_prefix) { "phrase" }
  let(:the_locale_name) { "fooish" }
  let(:the_default_name) { "messages" }
  let(:the_locale_code) { "en" }
  let(:the_extension) { "en" }
  let(:the_locale) { Phrase::Tool::Locale.new(name: the_locale_name, code: the_locale_code) }

  describe "#self.directory_for_locale" do
    it "should return the path to the current dir" do
      Phrase::Formats::PlayProperties.directory_for_locale(the_locale).should eql(the_current_directory)
    end
  end

  describe "#self.supports_extension?" do
    subject { Phrase::Formats::PlayProperties.supports_extension?(the_extension) }

    it { should be_true }
  end

  describe "#self.filename_for_locale" do
    subject { Phrase::Formats::PlayProperties.filename_for_locale(the_locale) }

    it { should include the_prefix }
    it { should include the_default_name }
    it { should end_with the_locale_code }
  end

  describe "#self.locale_aware?" do
    subject { Phrase::Formats::PlayProperties.locale_aware? }

    it { should be_false }
  end

  describe "#self.renders_locale_as_extension?" do
    subject { Phrase::Formats::PlayProperties.renders_locale_as_extension? }

    it { should be_true }
  end
end
