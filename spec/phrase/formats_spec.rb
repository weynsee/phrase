require 'spec_helper'

describe Phrase::Formats do
  include RSpec::Helpers

  describe "#self.target_directory(format_name)" do
    subject { Phrase::Formats.target_directory(format_name) }

    context 'format is node_json' do
      let(:format_name) { 'node_json' }
      it { should == 'locales/' }
    end
  end

  describe "#self.directory_for_locale_in_format(locale, format_name)" do
    let(:locale) { Phrase::Tool::Locale.new(name: "fooish", code: "foo-ish") }

    subject { Phrase::Formats.directory_for_locale_in_format(locale, format_name) }

    context "format is yaml" do
      let(:format_name) { "yml" }
      it { should eql("./") }
    end

    context "format is gettext" do
      let(:format_name) { "gettext" }
      it { should eql("./fooish/") }
    end

    context "format is gettext template" do
      let(:format_name) { "gettext_template" }
      it { should eql("./") }
    end

    context "format is xml" do
      let(:format_name) { "xml" }
      it { should eql("values-foo-rISH") }
    end

    context "format is strings" do
      let(:format_name) { "strings" }
      it { should eql("foo_ISH.lproj") }
    end

    context "format is xlf" do
      let(:format_name) { "xlf" }
      it { should eql("./") }
    end

    context "format is qph" do
      let(:format_name) { "qph" }
      it { should eql("./") }
    end

    context "format is ts" do
      let(:format_name) { "ts" }
      it { should eql("./") }
    end

    context "format is json" do
      let(:format_name) { "json" }
      it { should eql("./") }
    end

    context "format is simple_json" do
      let(:format_name) { "simple_json" }
      it { should eql("./") }
    end

    context "format is nested_json" do
      let(:format_name) { "nested_json" }
      it { should eql("./") }
    end

    context "format is node_json" do
      let(:format_name) { "node_json" }
      it { should eql("./") }
    end

    context "format is resx" do
      let(:format_name) { "resx" }
      it { should eql("./") }
    end

    context "format is resx_windowsphone" do
      let(:format_name) { "resx_windowsphone" }
      it { should eql("./") }
    end

    context "format is ini" do
      let(:format_name) { "ini" }
      it { should eql("./") }
    end

    context "format is properties" do
      let(:format_name) { "properties" }
      it { should eql("./") }
    end

    context "format is properties_xml" do
      let(:format_name) { "properties_xml" }
      it { should eql("./") }
    end

    context "format is plist" do
      let(:format_name) { "plist" }
      it { should eql("./") }
    end

    context "format is php array" do
      let(:format_name) { "php_array" }
      it { should eql("./") }
    end
  end

  describe "#self.filename_for_locale_in_format(locale, format_name)" do
    let(:locale) { Phrase::Tool::Locale.new(name: "fooish", code: "foo-ish") }

    subject { Phrase::Formats.filename_for_locale_in_format(locale, format_name) }

    context "format is yaml" do
      let(:format_name) { "yml" }
      it { should eql("phrase.fooish.yml") }
    end

    context "format is gettext" do
      let(:format_name) { "gettext" }
      it { should eql("phrase.po") }
    end

    context "format is gettext pot" do
      let(:format_name) { "gettext_template" }
      it { should eql("phrase.pot") }
    end

    context "format is xml" do
      let(:format_name) { "xml" }
      it { should eql("strings.xml") }
    end

    context "format is strings" do
      let(:format_name) { "strings" }
      it { should eql("Localizable.strings") }
    end

    context "format is xlf" do
      let(:format_name) { "xlf" }
      it { should eql("phrase.fooish.xlf") }
    end

    context "format is tmx" do
      let(:format_name) { "tmx" }
      it { should eql("phrase.fooish.tmx") }
    end

    context "format is qph" do
      let(:format_name) { "qph" }
      it { should eql("phrase.fooish.qph") }
    end

    context "format is ts" do
      let(:format_name) { "ts" }
      it { should eql("phrase.fooish.ts") }
    end

    context "format is json" do
      let(:format_name) { "json" }
      it { should eql("phrase.fooish.json") }
    end

    context "format is simple json" do
      let(:format_name) { "simple_json" }
      it { should eql("phrase.fooish.json") }
    end

    context "format is node_json" do
      let(:format_name) { "node_json" }
      it { should eql("fooish.js") }
    end

    context "format is resx" do
      let(:format_name) { "resx" }
      it { should eql("phrase.fooish.resx") }
    end

    context "format is resx (windows phone)" do
      let(:format_name) { "resx_windowsphone" }
      it { should eql("phrase.fooish.resx") }
    end

    context "format is ini" do
      let(:format_name) { "ini" }
      it { should eql("phrase.fooish.ini") }
    end

    context "format is properties" do
      let(:format_name) { "properties" }
      it { should eql("phrase.fooish.properties") }
    end

    context "format is properties_xml" do
      let(:format_name) { "properties_xml" }
      it { should eql("phrase.fooish.xml") }
    end

    context "format is plist" do
      let(:format_name) { "plist" }
      it { should eql("phrase.fooish.plist") }
    end

    context "format is php_array" do
      let(:format_name) { "php_array" }
      it { should eql("phrase.fooish.php") }
    end

    context "format is laravel" do
      let(:format_name) { "laravel" }
      it { should eql("phrase.fooish.php") }
    end

    context "format is angular_translate" do
      let(:format_name) { "angular_translate" }
      it { should eql("phrase.fooish.json") }
    end
  end

  describe "#self.file_format_exposes_locale?(file_path)" do
    subject { Phrase::Formats.send(:file_format_exposes_locale?, file_path) }

    context "format = po" do
      let(:file_path) { "./fixtures/formats/translations.en.po" }

      it { should be_true }
    end

    context "format = pot" do
      let(:file_path) { "./fixtures/formats/translations.pot" }

      it { should be_false }
    end
  end

  describe "#self.handler_class_for_format(format_name)" do
    subject { Phrase::Formats.send(:handler_class_for_format, format_name) }

    context "format = yml" do
      let(:format_name) { "yml" }
      it { should == Phrase::Formats::Yaml }
    end

    context "format = yml_symfony" do
      let(:format_name) { "yml_symfony" }
      it { should == Phrase::Formats::YamlSymfony }
    end

    context "format = yml_symfony2" do
      let(:format_name) { "yml_symfony2" }
      it { should == Phrase::Formats::YamlSymfony2 }
    end

    context "format = gettext" do
      let(:format_name) { "gettext" }
      it { should == Phrase::Formats::Gettext }
    end

    context "format = gettext_template" do
      let(:format_name) { "gettext_template" }
      it { should == Phrase::Formats::GettextTemplate }
    end

    context "format = xml" do
      let(:format_name) { "xml" }
      it { should == Phrase::Formats::Xml }
    end

    context "format = strings" do
      let(:format_name) { "strings" }
      it { should == Phrase::Formats::Strings }
    end

    context "format = xlf" do
      let(:format_name) { "xlf" }
      it { should == Phrase::Formats::Xliff }
    end

    context "format = qph" do
      let(:format_name) { "qph" }
      it { should == Phrase::Formats::QtPhraseBook }
    end

    context "format = ts" do
      let(:format_name) { "ts" }
      it { should == Phrase::Formats::QtTranslationSource }
    end

    context "format = json" do
      let(:format_name) { "json" }
      it { should == Phrase::Formats::Json }
    end

    context "format = simple_json" do
      let(:format_name) { "simple_json" }
      it { should == Phrase::Formats::SimpleJson }
    end

    context "format = nested_json" do
      let(:format_name) { "nested_json" }
      it { should == Phrase::Formats::NestedJson }
    end

    context "format = node_json" do
      let(:format_name) { "node_json" }
      it { should == Phrase::Formats::NodeJson }
    end

    context "format = resx" do
      let(:format_name) { "resx" }
      it { should == Phrase::Formats::Resx }
    end

    context "format = resx_windowsphone" do
      let(:format_name) { "resx_windowsphone" }
      it { should == Phrase::Formats::ResxWindowsphone }
    end

    context "format = ini" do
      let(:format_name) { "ini" }
      it { should == Phrase::Formats::Ini }
    end

    context "format = tmx" do
      let(:format_name) { "tmx" }
      it { should == Phrase::Formats::Tmx }
    end

    context "format = properties" do
      let(:format_name) { "properties" }
      it { should == Phrase::Formats::Properties }
    end

    context "format = properties_xml" do
      let(:format_name) { "properties_xml" }
      it { should == Phrase::Formats::PropertiesXml }
    end

    context "format = plist" do
      let(:format_name) { "plist" }
      it { should == Phrase::Formats::Plist }
    end

    context "format = php_array" do
      let(:format_name) { "php_array" }
      it { should == Phrase::Formats::PhpArray }
    end

    context "format = laravel" do
      let(:format_name) { "laravel" }
      it { should == Phrase::Formats::Laravel }
    end

    context "format = angular_translate" do
      let(:format_name) { "angular_translate" }
      it { should == Phrase::Formats::AngularTranslate }
    end
  end

  describe "#self.guess_possible_file_format_from_file_path(file_path)" do
    subject { Phrase::Formats.send(:guess_possible_file_format_from_file_path, file_path) }

    context "file is .po" do
      let(:file_path) { "test.po" }
      it { should eql :gettext }
    end

    context "file is .pot" do
      let(:file_path) { "test.pot" }
      it { should eql :gettext_template }
    end

    context "file is .yml" do
      let(:file_path) { "test.yml" }
      it { should eql :yml }
    end

    context "file is .php" do
      let(:file_path) { "test.php" }
      it { should eql :php_array }
    end

    context "file is .xlf" do
      let(:file_path) { "test.xlf" }
      it { should eql :xlf }
    end

    context "file is .xliff" do
      let(:file_path) { "test.xliff" }
      it { should eql :xlf }
    end
  end
end

describe Phrase::Formats::Base do
  let(:the_current_directory) { "./" }
  let(:the_locale_name) { "fooish" }
  let(:the_locale) { Phrase::Tool::Locale.new(name: the_locale_name) }

  describe "#self.directory_for_locale" do
    it "should return the path to the current dir" do
      Phrase::Formats::Base.directory_for_locale(the_locale).should eql(the_current_directory)
    end
  end

  describe "#self.filename_for_locale" do
    it "should raise an error" do
      lambda {
        Phrase::Formats::Base.filename_for_locale("fooish")
      }.should raise_error(/not implemented/)
    end
  end

  describe "#self.extract_locale_name_from_file_path(file_path)" do
    subject { Phrase::Formats::Base.extract_locale_name_from_file_path("foo") }

    it { should be_nil }
  end

  describe "#self.locale_aware?" do
    subject { Phrase::Formats::Base.locale_aware? }

    it { should be_false }
  end
end
