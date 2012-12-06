require 'spec_helper'
describe Phrase::Tool::Formats::Custom do
  let(:config){ Phrase::Tool::Config.new }
  let(:locale){ stub({ :name => 'de', :code => nil }) }
  before do
    Phrase::Tool::Formats::Custom.stub(:config) { config }
  end
  
  describe "#self.directory_for_locale(locale)" do
    subject { Phrase::Tool::Formats::Custom.directory_for_locale(locale, :po) }
    it { should be_nil }
    
    context "config given" do
      before do
        config.locale_directory = "<locale.name>/"
      end
      it { should eql "de/" }
    end
    
    context "config given with format" do
      before do
        config.locale_directory = "<format>/<locale.name>/"
      end
      it { should eql "po/de/" }
    end
  end

  describe "#self.filename_for_locale(locale)" do
    subject { Phrase::Tool::Formats::Custom.filename_for_locale(locale, :po) }
    it { should be_nil }

    context "config given" do
      before do
        config.locale_filename = "<locale.name>"
      end
      it { should eql "de" }
    end
    
    context "config given with format" do
      before do
        config.locale_filename = "<locale.name>.<format>"
      end
      it { should eql "de.po" }
    end
  end

  describe "#self.target_directory" do
    subject { Phrase::Tool::Formats::Custom.target_directory }
    it { should be_nil }

    context "config given" do
      before do
        config.target_directory = "locales/"
      end
      it { should eql "locales/" }
    end
  end
end
