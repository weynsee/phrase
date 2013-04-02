require "spec_helper"
require "generators/phrase/install_generator"

describe Phrase::Generators::InstallGenerator do
  use_vcr_cassette "rails_install_generator"

  before(:each) do
    # Silence, please!
    Phrase::Tool::Commands::Init.any_instance.stub(:print_message)

    within_source_root do
      FileUtils.mkdir_p "config/environments"
      File.open("config/environments/production.rb", 'w') { |file| file.write("PhraseExampleApp::Application.configure do\n\nend") }
    end
  end

  describe "without auth token" do
    it { should output("No value provided for required options '--auth-token'") }
  end
  
  describe "initializer" do
    with_args "--auth-token=86a1dc43f1087c6339994b5356fe5064" do
      it { should generate("config/initializers/phrase.rb") { |c| c.should =~ /Phrase.configure/ } }
      it { should generate("config/initializers/phrase.rb") { |c| c.should =~ /config.auth_token = "86a1dc43f1087c6339994b5356fe5064"/ } }
      it { should generate("config/initializers/phrase.rb") { |c| c.should =~ /config.ignored_keys = \[\]/ } }
    end
  end

  describe "production environment settings" do
    with_args "--auth-token=86a1dc43f1087c6339994b5356fe5064 --default-locale=en" do
      it { should inject_into_file("config/environments/production.rb") }
      specify { subject.should generate {
          File.read("config/environments/production.rb").should include "# config.i18n.load_path = Dir[Rails.root.join('phrase', 'locales', '*.{yml}').to_s]"
        }
      }
    end
  end

  describe ".phrase config file" do
    with_args "--auth-token=86a1dc43f1087c6339994b5356fe5064" do
      it { should generate(".phrase") { |c| c.should =~ /\"secret\": \"86a1dc43f1087c6339994b5356fe5064\"/ } }
    end
  end

  describe "README message" do
    with_args "--auth-token=86a1dc43f1087c6339994b5356fe5064" do
      it { should output("Welcome to PhraseApp") }
      it { should output("https://phraseapp.com/support") }
      it { should output("https://phraseapp.com/docs") }
      it { should output("https://phraseapp.com/account/login") }
    end
  end
end
