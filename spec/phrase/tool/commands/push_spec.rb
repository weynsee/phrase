require "spec_helper"

describe Phrase::Tool::Commands::Push do
  let(:options) { stub }
  let(:args) { [] }
  let(:locale) { stub }
  let(:format) { stub }
  let(:tags) { stub }
  let(:recursive) { stub }
  let(:config) { stub(secret: "secr3t") }
  let(:command) { Phrase::Tool::Commands::Push.new(options, args) }
  
  subject { command }
  
  before(:each) do
    options.stub(:get).with(:locale).and_return(locale)
    options.stub(:get).with(:format).and_return(format)
    options.stub(:get).with(:tags).and_return(tags)
    options.stub(:get).with(:recursive).and_return(recursive)
    Phrase::Tool::Commands::Push.any_instance.stub(:config).and_return(config)
    Phrase::Tool::Commands::Push.any_instance.stub(:print_message)
    Phrase::Tool::Commands::Push.any_instance.stub(:print_error)
  end
  
  describe "#execute!" do
    it "is pending" do
      
    end
  end
  
  describe "#choose_files_to_upload" do
    it "is pending"
  end
  
  describe "#upload_files(files)" do
    before(:each) do
      subject.stub(:upload_file)
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
    let(:tags) { ["foo", "bar"] }
    let(:locale) { "fr" }
    
    before(:each) do
      subject.stub(:api_client).and_return(api_client)
    end
    
    context "file is a directory" do
      let(:file) { "spec/fixtures" }
      
      it "should skip upload" do
        api_client.should_not_receive(:upload)
        subject.send(:upload_file, file)
      end
    end
    
    context "file is invalid" do
      let(:file) { "spec/fixtures/edge/wrongext.doc" }
      
      it "should skip upload" do
        api_client.should_not_receive(:upload)
        subject.send(:upload_file, file)
      end
    end
    
    context "file is valid" do
      let(:file) { "spec/fixtures/yml/nice.en.yml" }
      
      it "should upload the file" do
        api_client.should_receive(:upload).with(file, kind_of(String), tags, locale)
        subject.send(:upload_file, file)
      end
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
  
  describe "#rails_default_locale_folder_available?" do
    it "is pending"
  end
end