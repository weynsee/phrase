require 'spec_helper'

describe Phrase::Tool do
  include RSpec::Helpers
  
  let(:argv) { stub }
  let(:api_client) { stub }
  let(:tool) do
    tool = Phrase::Tool.new(argv)
    tool.stub(:print_error)
    tool.stub(:print_message)
    tool
  end
  
  subject { tool }
  
  before(:each) do
    subject.stub(:puts)
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
        describe "file formats" do
          before(:each) do          
            api_client.should_receive(:upload)
          end
          
          it "can upload .yml" do
            phrase "push spec/fixtures/formats/translations.en.yml"
            out.should include "Uploading spec/fixtures/formats/translations.en.yml"
          end

          it "can upload .po" do
            phrase "push spec/fixtures/formats/translations.en.po"
            out.should include "Uploading spec/fixtures/formats/translations.en.po"
          end     
          
          it "can upload .resx" do
            phrase "push spec/fixtures/formats/translations.en.resx"
            out.should include "Uploading spec/fixtures/formats/translations.en.resx"
          end
          
          it "can upload .xml" do
            phrase "push spec/fixtures/formats/translations.en.xml"
            out.should include "Uploading spec/fixtures/formats/translations.en.xml"
          end
          
          it "can upload .strings" do
            phrase "push spec/fixtures/formats/translations.en.strings"
            out.should include "Uploading spec/fixtures/formats/translations.en.strings"
          end

          it "can upload .json" do
            phrase "push spec/fixtures/formats/translations.en.json"
            out.should include "Uploading spec/fixtures/formats/translations.en.json"
          end
          
          it "can upload .ts" do
            phrase "push spec/fixtures/formats/translations.en.ts"
            out.should include "Uploading spec/fixtures/formats/translations.en.ts"
          end
          
          it "can upload .qph" do
            phrase "push spec/fixtures/formats/translations.en.qph"
            out.should include "Uploading spec/fixtures/formats/translations.en.qph"
          end
          
          it "can upload .ini" do
            phrase "push spec/fixtures/formats/translations.en.ini"
            out.should include "Uploading spec/fixtures/formats/translations.en.ini"
          end
          
          it "can upload .plist" do
            phrase "push spec/fixtures/formats/translations.en.plist"
            out.should include "Uploading spec/fixtures/formats/translations.en.plist"
          end
          
          it "can upload .properties" do
            phrase "push spec/fixtures/formats/translations.en.properties"
            out.should include "Uploading spec/fixtures/formats/translations.en.properties"
          end
          
          it "can upload .xlf" do
            phrase "push spec/fixtures/formats/translations.en.xlf"
            out.should include "Uploading spec/fixtures/formats/translations.en.xlf"
          end
        end
        
        context "tag(s) given" do
          it "should use the tag in the upload call" do
            api_client.should_receive(:upload).with(kind_of(String), kind_of(String), ["foobar"], nil)
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
      
      context "file extension is not supported" do        
        it "does not upload the file" do
          phrase "push spec/fixtures/edge/wrongext.doc"
          api_client.should_not_receive(:upload)
        end
        
        it "should display an error message" do
          phrase "push spec/fixtures/edge/wrongext.doc"
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
      
      context "without -R/--recursive" do
        it "should only push the files in the given directory (without subfolders)" do
          phrase "push spec/fixtures/mixed"
          out.should_not match %r=(subitem.yml)=im
        end
      end
      
      context "with -R/--recursive" do
        it "should push all files recursively" do
          phrase "push -R spec/fixtures/mixed"
          out.should match %r=(subitem.yml)=im
        end
      end
    end
  end
  
  describe "pull command" do
    before(:each) do
      Phrase::Api::Client.stub(:new).and_return(api_client)
      ::FileUtils.rm_rf("phrase/locales/")
      
      api_client.stub(:download_translations_for_locale).with("pl", kind_of(String)).and_return("content for pl")
      api_client.stub(:download_translations_for_locale).with("ru", kind_of(String)).and_return("content for ru")
      api_client.stub(:download_translations_for_locale).with("de", kind_of(String)).and_return("content for de")
      api_client.stub(:download_translations_for_locale).with("cn", kind_of(String)).and_raise("Error")
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
      
      describe "format handling" do
        context "no format is specified" do
          it "should fetch translations for the locale in yml format and store it" do
            phrase "pull ru"
            File.read("phrase/locales/phrase.ru.yml").should == "content for ru"
          end
        end

        context "an invalid format is specified" do
          it "should not fetch translations" do
            begin
              phrase "pull ru --format=doc"
            rescue SystemExit => ex
              err.should include "Invalid format"
              File.exists?("phrase/locales/phrase.ru.doc").should be_false
            end
          end
        end

        context "valid format is specified" do
          it "should store in po format" do
            phrase "pull ru --format=po"
            File.read("phrase/locales/phrase.ru.po").should == "content for ru"
          end
          
          it "should store in yml format" do
            phrase "pull ru --format=yml"
            File.read("phrase/locales/phrase.ru.yml").should == "content for ru"
          end
          
          it "should store in xml format" do
            phrase "pull ru --format=xml"
            File.read("phrase/locales/phrase.ru.xml").should == "content for ru"
          end
          
          it "should store in strings format" do
            phrase "pull ru --format=strings"
            File.read("phrase/locales/phrase.ru.strings").should == "content for ru"
          end
          
          it "should store in xlf format" do
            phrase "pull ru --format=xlf"
            File.read("phrase/locales/phrase.ru.xlf").should == "content for ru"
          end
          
          it "should store in qph format" do
            phrase "pull ru --format=qph"
            File.read("phrase/locales/phrase.ru.qph").should == "content for ru"
          end
          
          it "should store in ts format" do
            phrase "pull ru --format=ts"
            File.read("phrase/locales/phrase.ru.ts").should == "content for ru"
          end
          
          it "should store in json format" do
            phrase "pull ru --format=json"
            File.read("phrase/locales/phrase.ru.json").should == "content for ru"
          end
          
          it "should store in resx format" do
            phrase "pull ru --format=resx"
            File.read("phrase/locales/phrase.ru.resx").should == "content for ru"
          end
          
          it "should store in ini format" do
            phrase "pull ru --format=ini"
            File.read("phrase/locales/phrase.ru.ini").should == "content for ru"
          end
          
          it "should store in properties format" do
            phrase "pull ru --format=properties"
            File.read("phrase/locales/phrase.ru.properties").should == "content for ru"
          end
          
          it "should store in plist format" do
            phrase "pull ru --format=plist"
            File.read("phrase/locales/phrase.ru.plist").should == "content for ru"
          end
        end
      end
      
      context "a target folder is specified" do
        before(:each) do
          ::FileUtils.rm_rf("inexistant/folder/")
        end
        
        after(:each) do
          ::FileUtils.rm_rf("inexistant/folder/")
        end
        
        it "should fetch translations and store it in the given directory" do
          phrase "pull ru --target=phrase/"
          File.read("phrase/phrase.ru.yml").should == "content for ru"
        end
        
        context "target folder does not exist" do
          before(:each) do
            phrase "pull ru --target=inexistant/folder"
          end
          
          it "should create the folder and save the content" do
            File.exists?("inexistant/folder/phrase.ru.yml").should be_true
          end
        end
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
      
      context "a target folder is specified" do
        before(:each) do
          ::FileUtils.rm_rf("phrase/phrase.de.yml")
          ::FileUtils.rm_rf("phrase/phrase.pl.yml")
        end
        
        after(:each) do
          ::FileUtils.rm_rf("phrase/phrase.de.yml")
          ::FileUtils.rm_rf("phrase/phrase.pl.yml")
        end
        
        it "should fetch translations and store it in the given directory" do
          phrase "pull --target=phrase/"
          File.read("phrase/phrase.de.yml").should == "content for de"
          File.read("phrase/phrase.pl.yml").should == "content for pl"
        end
        
        context "target folder does not exist" do
          before(:each) do
            ::FileUtils.rm_rf("inexistant/folder")
            phrase "pull --target=inexistant/folder"
          end
          
          after(:each) do
            ::FileUtils.rm_rf("inexistant/folder")
          end
          
          it "should not save the content" do
            File.exists?("inexistant/folder/phrase.de.yml").should be_true
            File.exists?("inexistant/folder/phrase.pl.yml").should be_true
          end
        end
      end
    end
  end
  
  describe "#fetch_translations_for_locale" do
    let(:api_client) { stub(:download_translations_for_locale => "foo:\n  bar: content") }
    
    before(:each) do
      subject.stub(:store_translations_file)
    end
    
    it "fetches translations for a locale" do
      api_client.should_receive(:download_translations_for_locale).with("fr", kind_of(String))
      subject.send(:fetch_translations_for_locale, "fr")
    end
    
    context "translations can be downloaded" do
      it "should display a success message" do
        subject.should_receive(:print_message).with("OK")
        subject.send(:fetch_translations_for_locale, "fr")
      end
      
      it "should save the content to a file" do
        subject.should_receive(:store_translations_file).with("fr", "foo:\n  bar: content", kind_of(String), kind_of(String))
        subject.send(:fetch_translations_for_locale, "fr")
      end
    end
    
    context "translations cannot be downloaded" do
      before(:each) do
        api_client.stub(:download_translations_for_locale).and_raise("Error")
        subject.stub(:print_server_error)
      end
      
      it "should display failure message" do
        subject.should_receive(:print_error).with("Failed")
        subject.send(:fetch_translations_for_locale, "fr")
      end
      
      it "should render the server error" do
        subject.should_receive(:print_server_error)
        subject.send(:fetch_translations_for_locale, "fr")
      end
    end
  end
  
  describe "#choose_files_to_upload" do
    
  end
  
  describe "#upload_files(files, tags=[], locale=nil)" do
    let(:tool) { Phrase::Tool.new([]) }
    let(:tags) { stub }
    let(:locale) { "en" }
    
    before(:each) do
      tool.stub(:upload_file)
    end
    
    it "uploads each file" do
      tool.should_receive(:upload_file).with("foo.txt", tags, locale)
      tool.should_receive(:upload_file).with("bar.txt", tags, locale)
      tool.send(:upload_files, ["foo.txt", "bar.txt"], tags, locale)
    end
  end
  
  describe "#upload_file(file, tags=[], locale=nil)" do
    let(:api_client) { stub(upload: true) }
    let(:file) { "foo.txt" }
    let(:tags) { [] }
    let(:locale) { nil }
    
    before(:each) do
      subject.stub(:api_client).and_return(api_client)
    end
    
    context "file is a directory" do
      let(:file) { "spec/fixtures" }
      
      it "should skip upload" do
        api_client.should_not_receive(:upload)
        subject.send(:upload_file, file, tags, locale)
      end
    end
    
    context "file is invalid" do
      let(:file) { "spec/fixtures/edge/wrongext.doc" }
      
      it "should skip upload" do
        api_client.should_not_receive(:upload)
        subject.send(:upload_file, file, tags, locale)
      end
    end
    
    context "file is valid" do
      let(:file) { "spec/fixtures/yml/nice.en.yml" }
      
      it "should upload the file" do
        api_client.should_receive(:upload).with(file, kind_of(String), tags, locale)
        subject.send(:upload_file, file, tags, locale)
      end
    end
  end
  
  describe "#store_translations_file" do
    before(:each) do
      %w(yml txt).each { |format| File.delete("phrase/locales/phrase.foo.#{format}") if File.exists?("phrase/locales/phrase.foo.#{format}") }
    end
    
    after(:each) do
      %w(yml txt).each { |format| File.delete("phrase/locales/phrase.foo.#{format}") if File.exists?("phrase/locales/phrase.foo.#{format}") }
    end
    
    context "file does not exist" do
      it "should store content to a file" do
        subject.send(:store_translations_file, "foo", "mycontent")
        File.read("phrase/locales/phrase.foo.yml").should == "mycontent"
      end
      
      it "should use the file extension given" do
        subject.send(:store_translations_file, "foo", "mycontent", "txt")
        File.read("phrase/locales/phrase.foo.txt").should == "mycontent"
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
        subject.should_receive(:print_message).with("Failed")
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
        subject.should_receive(:print_message).with("Created locale \"fr\"")
        subject.send(:create_locale, "fr")
      end
    end
    
    context "when locale cannot be created" do
      before(:each) do
        api_client.stub(:create_locale).and_raise("Error")
        subject.stub(:print_server_error)
      end
      
      it "should display an error message" do
        subject.should_receive(:print_message).with("Notice: Locale \"fr\" could not be created (maybe it already exists)")
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
        subject.should_receive(:print_message).with("Locale \"fr\" is now the default locale")
        subject.send(:make_locale_default, "fr")
      end
    end
    
    context "locale cannot be marked as default" do
      before(:each) do
        api_client.stub(:make_locale_default).and_raise("Error")
        subject.stub(:print_server_error)
      end
      
      it "should display an error message" do
        subject.should_receive(:print_message).with("Notice: Locale \"fr\" could not be made the default locale")
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
    subject { tool.send(:valid_tags_are_given?, tags) }
    
    context "all tags are valid" do
      let(:tags) { ["foo", "bar", "baz"] }
      
      it { should be_true }
    end
    
    context "at least one tag is invalid" do
      let(:tags) { ["foo", "bar", "b$z"] }
      
      it { should be_false }
    end
  end
  
  describe "#file_valid?(filename)" do
    let(:filename) { "foo.txt" }
    
    subject { tool.send(:file_valid?, filename) }
    
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
  
  describe "#print_message" do
    before(:each) do
      tool.unstub(:print_message)
    end
    
    let(:message) { "Hello Error!" }
    
    it "should print a message to stdout" do
      subject.should_receive(:puts).with(message)
      subject.send(:print_message, message)
    end
  end
  
  describe "#print_error" do
    before(:each) do
      tool.unstub(:print_error)
    end
    
    let(:message) { "Hello Error!" }
    
    it "should print a message to stderr" do
      $stderr.should_receive(:puts).with(message)
      subject.send(:print_error, message)
    end
  end
end