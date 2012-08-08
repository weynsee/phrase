require 'spec_helper'

describe Phrase::Tool do
  include RSpec::Helpers
  
  let(:api_client) { stub }
  
  subject {
    tool = Phrase::Tool.new(stub)
    tool.stub(:puts)
    tool
  }
  
  before(:each) do
    subject.stub(:api_client).and_return(api_client)
    File.delete(".phrase") if File.exists?(".phrase")
  end
  
  describe "default command" do
    it "prints usage instructions" do
      phrase ""
      err.should include "phrase init"
      err.should include "phrase push"
    end
  end

  describe "init command" do
    before(:each) do
      Phrase::Api::Client.stub(:new).and_return(api_client)
    end
    
    describe "config generation" do
      context "no secret is given" do
        it "displays an error message" do
          phrase_cmd "init"
          err.should include "Need a secret to init, but found none."
          err.should include "Please provide the --secret=YOUR_SECRET parameter."
        end      
      end

      context "a secret is given" do
        it "displays a success message" do
          phrase_cmd "init --secret=foo"
          out.should include "Wrote secret to config file .phrase"
        end  

        it "should write the secret to the config file" do
          phrase_cmd "init --secret=my_secret_key"
          File.read('.phrase').should include "my_secret_key"
        end
      end      
    end
    
    describe "default locale" do
      context "--default-locale is given" do
        context "locale does not exist yet" do
          before(:each) do
            api_client.stub(:create_locale).with("hu").and_return(true)
            api_client.stub(:make_locale_default).with("hu").and_return(true)
          end
          
          it "creates the locale" do
            phrase "init --secret=my_secret --default-locale=hu"
            out.should include "Created locale \"hu\""
          end
          
          it "makes the locale default" do
            phrase "init --secret=my_secret --default-locale=hu"
            out.should include "Locale \"hu\" is now the default locale"
          end
        end
        
        describe "locale already exists" do
          before(:each) do
            api_client.stub(:create_locale).with("hu").and_raise("Error")
            api_client.stub(:make_locale_default).with("hu").and_return(true)
          end
          
          it "tells the user that it could not create the locale" do
            phrase "init --secret=my_secret --default-locale=hu"
            out.should_not include "Created locale \"hu\""            
          end
          
          it "makes the locale default" do
            phrase "init --secret=my_secret --default-locale=hu"
            out.should include "Locale \"hu\" is now the default locale"        
          end        
        end
      end
      
      context "--default-locale is not set" do
        context "en locale does not exist yet" do
          before(:each) do
            api_client.stub(:create_locale).with("en").and_return(true)
            api_client.stub(:make_locale_default).with("en").and_return(true)
          end
          
          it "creates the locale" do
            phrase "init --secret=my_secret"
            out.should include "Created locale \"en\""
          end        
          
          it "makes en the default locale" do
            phrase "init --secret=my_secret"
            out.should include "Locale \"en\" is now the default locale"
          end
        end
        
        context "en already exists" do
          before(:each) do
            api_client.stub(:create_locale).with("en").and_raise("Error")
            api_client.stub(:make_locale_default).with("en").and_return(true)
          end
          
          it "cannot create the locale" do
            phrase "init --secret=my_secret"
            out.should_not include "Created locale \"en\""
          end
          
          it "marks en as default" do
            phrase "init --secret=my_secret"
            out.should include "Locale \"en\" is now the default locale"
          end
        end
      end
    end
  end

  describe "push command" do
    before(:each) do
      Phrase::Api::Client.stub(:new).and_return(api_client)
    end
    
    before(:each) do
      api_client.stub(:create_locale).and_return(true)
      api_client.stub(:make_locale_default).and_return(true)
      api_client.stub(:upload).and_return(true)
    end
    
    it "complains when no config present" do
      begin
        phrase "push /path/to/some.yml"
      rescue SystemExit => ex
        err.should include "No config present. You need to initialize phrase first."
      end
    end
    
    context "when no file/dir specified" do
      context "rails default dir is not available" do
        it "displays an error message" do
          Phrase::Tool.stub(:rails_default_locale_folder_is_available).and_return(false)
          begin
            phrase "init --secret=my_secret"
            phrase "push"
          rescue SystemExit => ex
            err.should include "Need either a file or directory"
            err.should include "phrase push FILE"
            err.should include "phrase push DIRECTORY"
          end
        end
      end
      
      context "rails default dir is available" do
        it "uses ./config/locales as default directory" do
          Phrase::Tool.stub(:rails_default_locale_folder_is_available).and_return(true)
          begin
            phrase "init --secret=my_secret"
            phrase "push"
          rescue SystemExit => ex
            out.should include "No file or directory specified, using ./config/locales"
          end
        end
      end
    end
    
    context "file is given" do
      before(:each) do
        phrase "init --secret=my_secret"
      end
      
      context "file does not exist" do
        it "displays an error message" do
          begin
            phrase "push does_not_exist.yml"
          rescue SystemExit => ex
            err.chomp.should == "The file does_not_exist.yml could not be found."
          end
        end        
      end
      
      context "file exists" do
        it "uploads the file" do
          api_client.should_receive(:upload)
          phrase "push spec/fixtures/yml/nice.en.yml"
        end
        
        it "should display the success message" do
          phrase "push spec/fixtures/yml/nice.en.yml"
          out.should include "Uploading spec/fixtures/yml/nice.en.yml"
        end
        
        context "tag(s) given" do
          it "should use the tag in the upload call" do
            api_client.should_receive(:upload).with(kind_of(String), kind_of(String), ["foobar"])
            phrase "push spec/fixtures/yml/nice.en.yml --tags=foobar"
          end
          
          it "should mention the tag in the output" do
            phrase "push spec/fixtures/yml/nice.en.yml --tags=foo,bar"
            out.should include "(tagged: foo, bar)"
          end
          
          context "tag name is invalid" do            
            it "should not perform the upload" do
              begin
                phrase "push spec/fixtures/yml/nice.en.yml --tags=tes$"
              rescue SystemExit => ex
                err.should include "Invalid tags"
              end
            end
          end
        end
      end
      
      context "file does not end in yml" do        
        it "does not upload the file" do
          phrase "push spec/fixtures/edge/wrongext.yml.txt"
          api_client.should_not_receive(:upload)
        end
        
        it "should display an error message" do
          phrase "push spec/fixtures/edge/wrongext.yml.txt"
          err.should match "Notice: Could not upload"
        end
      end
    end
    
    context "directory is given" do
      before(:each) do
        phrase "init --secret=my_secret"
      end
    
      it "uploads every file from the directoy" do
        phrase "push spec/fixtures/yml"
        out.should match %r=Uploading.*spec/fixtures/yml/nice.de.yml=im
        out.should match %r=Uploading.*spec/fixtures/yml/nice.en.yml=im
      end
      
      it "skips files with unsupported file extensions but uploads correct files" do
        phrase "push spec/fixtures/mixed"
        err.should match %r=(Notice: Could not upload .*spec/fixtures/mixed/wrong.yml.rb)=
        out.should match %r=(Uploading .*spec/fixtures/mixed/nice.yml)=im
      end
    end
  end
  
  describe "pull command" do
    before(:each) do
      Phrase::Api::Client.stub(:new).and_return(api_client)
      ::FileUtils.rm_rf("phrase/locales/")
      api_client.stub(:download_translations_for_locale).with("pl").and_return("content for pl")
      api_client.stub(:download_translations_for_locale).with("ru").and_return("content for ru")
      api_client.stub(:download_translations_for_locale).with("de").and_return("content for de")
      api_client.stub(:download_translations_for_locale).with("cn").and_raise("Error")
    end
    
    it "complains when no config present" do
      begin
        phrase "pull fr"
      rescue SystemExit => ex
        err.should include "No config present. You need to initialize phrase first."
      end
    end
    
    it "should create the locales folder" do
      phrase "init --secret=my_secret"
      phrase "pull fr"
      File.directory?("phrase/locales/").should be_true
    end
    
    context "locale is invalid" do
      it "should render an error" do
        phrase "init --secret=my_secret"
        phrase "pull cn"
        File.exists?("phrase/locales/phrase.cn.yml").should be_false
        err.should include "Error"
      end
    end
  
    context "a locale is given" do
      before(:each) do
        phrase "init --secret=my_secret"
      end
      
      it "should fetch translations for the locale and store it" do
        phrase "pull ru"
        File.read("phrase/locales/phrase.ru.yml").should == "content for ru"
      end
    end
    
    context "no locale is given" do
      let(:list_of_locales) { ["de", "pl"] }
      
      before(:each) do
        phrase "init --secret=my_secret"
        api_client.stub(:fetch_locales).and_return(list_of_locales)
      end
      
      it "should download each translation file and store it" do
        api_client.should_receive(:fetch_locales).and_return(["de", "pl"])
        phrase "pull"
        File.read("phrase/locales/phrase.de.yml").should == "content for de"
        File.read("phrase/locales/phrase.pl.yml").should == "content for pl"
      end
    end
  end
  
  describe "#fetch_translations_for_locale" do
    let(:api_client) { stub(:download_translations_for_locale => "foo:\n  bar: content") }
    
    before(:each) do
      subject.stub(:store_translations_file)
    end
    
    it "fetches translations for a locale" do
      api_client.should_receive(:download_translations_for_locale).with("fr")
      subject.send(:fetch_translations_for_locale, "fr")
    end
    
    context "translations can be downloaded" do
      it "should display a success message" do
        subject.should_receive(:puts).with("OK")
        subject.send(:fetch_translations_for_locale, "fr")
      end
      
      it "should save the content to a file" do
        subject.should_receive(:store_translations_file).with("fr", "foo:\n  bar: content")
        subject.send(:fetch_translations_for_locale, "fr")
      end
    end
    
    context "translations cannot be downloaded" do
      before(:each) do
        api_client.stub(:download_translations_for_locale).and_raise("Error")
        subject.stub(:print_server_error)
      end
      
      it "should display failure message" do
        subject.should_receive(:puts).with("Failed")
        subject.send(:fetch_translations_for_locale, "fr")
      end
      
      it "should render the server error" do
        subject.should_receive(:print_server_error)
        subject.send(:fetch_translations_for_locale, "fr")
      end
    end
  end
  
  describe "#upload_files" do
    it "is pending"
  end
  
  describe "#store_translations_file" do
    before(:each) do
      File.delete("phrase/locales/phrase.foo.yml") if File.exists?("phrase/locales/phrase.foo.yml")
    end
    
    after(:each) do
      File.delete("phrase/locales/phrase.foo.yml") if File.exists?("phrase/locales/phrase.foo.yml")
    end
    
    context "file does not exist" do
      it "should store content to a file" do
        subject.send(:store_translations_file, "foo", "mycontent")
        File.read("phrase/locales/phrase.foo.yml").should == "mycontent"
      end
    end
    
    context "file exists" do
      before(:each) do
        File.open("phrase/locales/phrase.foo.yml", "w") do |file|
          file.write("hello")
        end
      end
      
      it "should override the file" do
        subject.send(:store_translations_file, "foo", "mycontent")
        File.read("phrase/locales/phrase.foo.yml").should == "mycontent"
      end
    end
  end
  
  describe "#fetch_locales" do
    it "should fetch the locales" do
      api_client.should_receive(:fetch_locales)
      subject.send(:fetch_locales)
    end
    
    context "locales could be fetched" do
      let(:locales) { stub }
      
      before(:each) do
        api_client.stub(:fetch_locales).and_return(locales)
      end
      
      it "should return the lcoales" do
        subject.send(:fetch_locales).should == locales
      end
    end
    
    context "locales could not be fetched" do
      before(:each) do
        api_client.stub(:fetch_locales).and_raise("Error")
        subject.stub(:print_server_error)
        subject.stub(:exit)
      end
      
      it "should terminate the script" do
        subject.should_receive(:exit)
        subject.send(:fetch_locales)
      end
      
      it "should display an error message" do
        subject.should_receive(:puts).with("Failed")
        subject.send(:fetch_locales)
      end
    end
  end
  
  describe "#create_locale" do
    let(:api_client) { stub(:create_locale => true) }
    
    it "should create a locale" do
      api_client.should_receive(:create_locale).with("fr")
      subject.send(:create_locale, "fr")
    end
    
    context "when locale can be created" do
      it "should display a success message" do
        subject.should_receive(:puts).with("Created locale \"fr\"")
        subject.send(:create_locale, "fr")
      end
    end
    
    context "when locale cannot be created" do
      before(:each) do
        api_client.stub(:create_locale).and_raise("Error")
        subject.stub(:print_server_error)
      end
      
      it "should display an error message" do
        subject.should_receive(:puts).with("Notice: Locale \"fr\" could not be created (maybe it already exists)")
        subject.send(:create_locale, "fr")
      end
    end
  end
  
  describe "#make_locale_default" do
    let(:api_client) { stub(:make_locale_default => true) }
    
    it "marks a locale as default" do
      api_client.should_receive(:make_locale_default).with("fr")
      subject.send(:make_locale_default, "fr")
    end
    
    context "locale can be marked as default" do
      it "should display the success message" do
        subject.should_receive(:puts).with("Locale \"fr\" is now the default locale")
        subject.send(:make_locale_default, "fr")
      end
    end
    
    context "locale cannot be marked as default" do
      before(:each) do
        api_client.stub(:make_locale_default).and_raise("Error")
        subject.stub(:print_server_error)
      end
      
      it "should display an error message" do
        subject.should_receive(:puts).with("Notice: Locale \"fr\" could not be made the default locale")
        subject.send(:make_locale_default, "fr")
      end
      
      it "should render the server error" do
        subject.should_receive(:print_server_error)
        subject.send(:make_locale_default, "fr")
      end
    end
  end
  
  describe "#api_client" do
    it "returns an instance of an api client" do
      tool = Phrase::Tool.new([])
      tool.config = stub(:secret => "foo")
      tool.send(:api_client).should be_a Phrase::Api::Client
    end
    
    it "should be configured with the correct auth token" do
      tool = Phrase::Tool.new([])
      tool.config = stub(:secret => "foo")
      tool.send(:api_client).auth_token.should == "foo"
    end
  end
  
  describe "#valid_tags_are_given?(tags)" do
    it "returns true if all tags are valid" do
      tool = Phrase::Tool.new([])
      tool.send(:valid_tags_are_given?, ["foo", "bar", "baz"]).should be_true      
    end
    
    it "returns false if at least one tag is invalid" do
      tool = Phrase::Tool.new([])
      tool.send(:valid_tags_are_given?, ["foo", "bar", "b$z"]).should be_false
    end
  end
end