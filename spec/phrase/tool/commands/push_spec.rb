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
          api_client.should_receive(:upload).with(file, kind_of(String), [], nil, nil, false)
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
          api_client.should_receive(:upload).with(file, kind_of(String), [], "default-locale", nil, false)
          subject.send(:upload_file, file)
        end
      end
    end
  end
  
  describe "#force_use_of_default_locale?(file_path)" do
    subject { command.send(:force_use_of_default_locale?, file_path) }
    
    context "is a gettext file" do
      let(:file_path) { "./fixtures/formats/translations.en.po" }
      
      it { should be_false }
    end
    
    context "is a gettext pot file" do
      let(:file_path) { "./fixtures/formats/translations.pot" }
      
      it { should be_true }
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
    
  describe "#detect_locale_name_from_file_path(file_path)" do
    subject { command.send(:detect_locale_name_from_file_path, file_path) }
    
    context "extension is unknown" do
      let(:file_path) { "test.doc" }

      it { should be_nil }
    end
  end
end
