require "spec_helper"

describe Phrase::Tool::Commands::Pull do
  let(:format) { "yml" }
  let(:target) { "./phrase/locales" }
  let(:options) { stub }
  let(:args) { [] }
  let(:api_client) { stub }
  let(:config) { stub(secret: "secr3t") }
  
  before(:each) do
    options.stub(:get).with(:format).and_return(format)
    options.stub(:get).with(:target).and_return(target)
    Phrase::Tool::Commands::Pull.any_instance.stub(:config).and_return(config)
    Phrase::Tool::Commands::Pull.any_instance.stub(:print_message)
    Phrase::Tool::Commands::Pull.any_instance.stub(:print_error)
  end
  
  subject { Phrase::Tool::Commands::Pull.new(options, args) }
  
  context "no auth token is given" do
    let(:config) { stub(secret: nil) }
    
    it "should exit when no secret key given" do
      lambda {
        Phrase::Tool::Commands::Pull.new(options, args)
      }.should raise_error SystemExit
    end    
  end
  
  describe "#execute!" do
    before(:each) do
      subject.stub(:fetch_locales).and_return(["ru", "pl"])
    end
    
    context "when a locale was given" do
      let(:args) { [nil, "fr"] }
      
      it "should fetch the given locale" do
        subject.should_receive(:print_message).with(/downloading phrase.fr.yml/i)
        subject.should_receive(:fetch_translations_for_locale).with("fr", "yml")
        subject.execute!
      end
    end
    
    context "when no locale was given" do
      let(:args) { [] }
      
      it "should fetch all locales" do
        subject.should_receive(:print_message).with(/downloading phrase.ru.yml/i)
        subject.should_receive(:print_message).with(/downloading phrase.pl.yml/i)
        subject.should_receive(:fetch_translations_for_locale).with("ru", "yml")
        subject.should_receive(:fetch_translations_for_locale).with("pl", "yml")
        subject.execute!
      end
    end
  end
  
  describe "#fetch_translations_for_locale" do
    let(:api_client) { stub(:download_translations_for_locale => "foo:\n  bar: content") }
    
    before(:each) do
      subject.stub(:print_error)
      subject.stub(:print_server_error)
      subject.stub(:print_message)
      subject.stub(:api_client).and_return(api_client)
      subject.stub(:store_translations_file)
    end
    
    it "fetches translations for a locale" do
      api_client.should_receive(:download_translations_for_locale).with("fr", "yml")
      subject.send(:fetch_translations_for_locale, "fr", "yml")
    end
    
    context "translations can be downloaded" do
      it "should display a success message" do
        subject.should_receive(:print_message).with("OK")
        subject.send(:fetch_translations_for_locale, "fr", "yml")
      end
      
      it "should save the content to a file" do
        subject.should_receive(:store_content_in_locale_file).with("fr", "foo:\n  bar: content")
        subject.send(:fetch_translations_for_locale, "fr", "yml")
      end
    end
    
    context "translations cannot be downloaded" do
      before(:each) do
        api_client.stub(:download_translations_for_locale).and_raise("Error")
        subject.stub(:print_server_error)
      end
      
      it "should display failure message" do
        subject.should_receive(:print_error).with("Failed")
        subject.send(:fetch_translations_for_locale, "fr", "yml")
      end
      
      it "should render the server error" do
        subject.should_receive(:print_server_error)
        subject.send(:fetch_translations_for_locale, "fr", "yml")
      end
    end

  end
  
  describe "#store_content_in_locale_file(locale_name, content)" do
    before(:each) do
      %w(yml txt).each { |format| File.delete("phrase/locales/phrase.foo.#{format}") if File.exists?("phrase/locales/phrase.foo.#{format}") }
    end

    after(:each) do
      %w(yml txt).each { |format| File.delete("phrase/locales/phrase.foo.#{format}") if File.exists?("phrase/locales/phrase.foo.#{format}") }
    end

    context "file does not exist" do
      it "should store content to a file" do
        subject.send(:store_content_in_locale_file, "foo", "mycontent")
        File.read("phrase/locales/phrase.foo.yml").should == "mycontent"
      end
    end

    context "file exists" do
      before(:each) do
        FileUtils.mkpath("phrase/locales/")
        File.open("phrase/locales/phrase.foo.yml", "w") do |file|
          file.write("hello")
        end
      end

      it "should override the file" do
        subject.send(:store_content_in_locale_file, "foo", "mycontent")
        File.read("phrase/locales/phrase.foo.yml").should == "mycontent"
      end
    end
  end
  
  describe "#fetch_locales" do
    before(:each) do
      subject.stub(:print_error)
      subject.stub(:print_server_error)
      subject.stub(:print_message)
      subject.stub(:api_client).and_return(api_client)
    end
    
    context "locales could be fetched" do
      let(:locales) { stub }
      
      before(:each) do
        api_client.stub(:fetch_locales).and_return(locales)
      end
      
      it "should return the locales" do
        subject.send(:fetch_locales).should == locales
      end
    end
    
    context "locales could not be fetched" do
      before(:each) do
        api_client.stub(:fetch_locales).and_raise("Some server error")
      end
      
      it "should terminate the script" do
        lambda {
          subject.send(:fetch_locales)
        }.should raise_error SystemExit
      end
      
      it "should display an error message" do
        subject.stub(:exit_command)
        subject.should_receive(:print_error).with(/could not fetch locales from server/i)
        subject.send(:fetch_locales)
      end
    end 
  end
  
  describe "#format_valid?" do
    subject { Phrase::Tool::Commands::Pull.new(options, args).send(:format_valid?, format) }
    
    context "format is in list of valid formats" do
      let(:format) { "yml" }
      it { should be_true }
    end
    
    context "format is not in list of valid formats" do
      let(:format) { "foo" }
      it { should be_false }
    end
  end
end