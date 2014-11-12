require "spec_helper"

describe Phrase::Tool::Commands::Push do
  let(:args) { [] }
  let(:options) { Phrase::Tool::Options.new(args, "push") }
  let(:config) { stub(secret: "secr3t") }
  let(:command) { Phrase::Tool::Commands::Push.new(options, args) }

  subject { command }

  before(:each) do
    Phrase::Tool::Commands::Push.any_instance.stub(:config).and_return(config)
    Phrase::Tool::Commands::Push.any_instance.stub(:print_message)
    Phrase::Tool::Commands::Push.any_instance.stub(:print_error)
  end

  describe "#upload_files(files)" do
    before(:each) do
      subject.stub(:upload_file)
      subject.stub(:file_exists?).and_return(true)
    end

    it "uploads each file" do
      subject.should_receive(:upload_file).with("foo.txt")
      subject.should_receive(:upload_file).with("bar.txt")

      subject.send(:upload_files, ["foo.txt", "bar.txt"])
    end
  end

  describe "#upload_file(file)" do
    let(:api_client) { stub(upload: true) }
    let(:file) { "foo.txt" }

    before(:each) do
      subject.stub(:api_client).and_return(api_client)
    end

    context "file is invalid" do
      let(:file) { "spec/fixtures/edge/wrongext.doc" }

      it "should skip upload" do
        api_client.should_not_receive(:upload)
        subject.send(:upload_file, file)
      end
    end

    context "file is valid" do
      context "file provides a locale information" do
        let(:file) { "spec/fixtures/yml/nice.en.yml" }

        it "should upload the file" do
          api_client.should_receive(:upload).with(file, kind_of(String), [], nil, nil, false, false, false, nil)
          subject.send(:upload_file, file)
        end
      end

      context "file does not provide a locale information" do
        let(:file) { "spec/fixtures/edge/nice.pot" }
        let(:default_locale) { stub(name: "default-locale") }

        before(:each) do
          Phrase::Tool::Locale.stub(:find_default_locale).and_return(default_locale)
        end

        it "should upload the file with the default locale assigned" do
          api_client.should_receive(:upload).with(file, kind_of(String), [], "default-locale", nil, false, false, false, nil)
          subject.send(:upload_file, file)
        end
      end
    end
  end

  describe "#file_format_exposes_locale?(file_path, format)" do
    let(:format){ nil }
    subject { command.send(:file_format_exposes_locale?, file_path, format) }

    context "is a gettext file" do
      let(:file_path) { "./fixtures/formats/translations.en.po" }

      it { should be_true }
    end

    context "is a gettext pot file" do
      let(:file_path) { "./fixtures/formats/translations.pot" }

      it { should be_false }
    end

    context "format is known (xml) and locale aware" do
      let(:file_path) { "src/main/res/values-de/strings.xml" }
      let(:format){ "xml" }

      it { should be_true }
    end

    context "format is known (yml) and locale aware" do
      let(:file_path) { "config/locales/en.yml" }
      let(:format){ "yml" }

      it { should be_true }
    end

    context "format is known (simple_json) and not locale aware" do
      let(:file_path) { "some/en.json" }
      let(:format){ "simple_json" }

      it { should be_false }
    end
  end

  describe "#file_valid?(filename)" do
    let(:filename) { "foo.txt" }

    subject { command.send(:file_valid?, filename) }

    context "file is doc file" do
      let(:filename) { "spec/fixtures/edge/wrongext.doc" }

      it { should be_false }
    end

    context "file is yaml file" do
      let(:filename) { "spec/fixtures/yml/nice.en.yml" }

      it { should be_true }
    end

    context "file is pot file" do
      let(:filename) { "spec/fixtures/gettext/nice.en.pot" }

      it { should be_true }
    end

    context "file is po file" do
      let(:filename) { "spec/fixtures/gettext/nice.en.po" }

      it { should be_true }
    end
  end

  describe "#valid_tags_are_given?(tags)" do
    subject { command.send(:valid_tags_are_given?, tags) }

    context "all tags are valid" do
      let(:tags) { ["foo", "bar", "baz"] }

      it { should be_true }
    end

    context "at least one tag is invalid" do
      let(:tags) { ["foo", "b$z", "bar"] }

      it { should be_false }
    end
  end

  describe "#detect_locale_name_from_file_path(file_path, format)" do
    let(:format) { nil }
    subject { command.send(:detect_locale_name_from_file_path, file_path, format) }

    context "extension is unknown" do
      let(:file_path) { "test.doc" }

      it { should be_nil }
    end

    context "format is known (xml) and locale aware" do
      let(:file_path) { "src/main/res/values-de/strings.xml" }
      let(:format){ "xml" }

      it { should == "de" }
    end

    context "format is known (strings) and locale aware" do
      let(:file_path) { "/en.lproj/Localizable.strings" }
      let(:format){ "strings" }

      it { should == "en" }
    end

    context "format is known (simple_json) and not locale aware" do
      let(:file_path) { "some/en.json" }
      let(:format){ "simple_json" }

      it { should == nil }
    end
  end

  describe "#choose_files_to_upload(file_names, recursive)" do
    subject { command.send(:choose_files_to_upload, files, recursive).sort }
    let(:recursive) { false }

    context "one file" do
      let(:files) { ["spec/fixtures/yml/nice.en.yml"].sort }

      it { should == files }
    end

    context "two files" do
      let(:files) { ["spec/fixtures/yml/nice.en.yml", "spec/fixtures/yml/nice.de.yml"].sort }

      it { should == files }
    end

    context "folder" do
      let(:files) { ["spec/fixtures/mixed"] }

      it { should == [File.expand_path('spec/fixtures/mixed/nice.yml'), File.expand_path('spec/fixtures/mixed/wrong.yml.rb')].sort }
    end

    context "folder recursive" do
      let(:files) { ["spec/fixtures/mixed"] }
      let(:recursive) { true }

      it { should == [File.expand_path('spec/fixtures/mixed/nice.yml'), File.expand_path('spec/fixtures/mixed/subfolder/subitem.yml'), File.expand_path('spec/fixtures/mixed/wrong.yml.rb')].sort }
    end
  end
end




