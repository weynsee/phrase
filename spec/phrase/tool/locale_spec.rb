require 'spec_helper'

describe Phrase::Tool::Locale do
  let(:attrs) { {id: 42, name: "fr", code: "fr-FR", is_default: true} }

  subject { Phrase::Tool::Locale.new(attrs) }

  it { subject.id.should eql(42) }
  it { subject.name.should eql("fr") }
  it { subject.code.should eql("fr-FR") }
  it { subject.default?.should be_true }

  describe "#self.all" do
    let(:api_client) { stub(fetch_locales: locale_data) }
    let(:locale_data) { [{name: "fr"}] }

    subject { Phrase::Tool::Locale.all }

    before(:each) do
      Phrase::Tool::Locale.stub(:api_client).and_return(api_client)
    end

    it { should be_an Array }
    specify { subject.first.should be_a Phrase::Tool::Locale }
  end

  describe "#self.find_default_locale" do
    let(:api_client) { stub(fetch_locales: locale_data) }
    let(:locale_data) { [] }

    subject { Phrase::Tool::Locale.find_default_locale }

    before(:each) do
      Phrase::Tool::Locale.stub(:api_client).and_return(api_client)
    end

    context "no default locale is set" do
      it { should be_nil }
    end

    context "a default locale is set" do
      let(:locale_data ) { [{name: "de", is_default: true}] }

      it { should be_a Phrase::Tool::Locale }
    end
  end

  describe "#self.config" do
    subject { Phrase::Tool::Locale.send(:config) }

    it { should be_a Phrase::Tool::Config }
  end

  describe "#self.api_client" do
    let(:config) { stub(secret: "foo") }

    before(:each) do
      Phrase::Tool::Locale.stub(:config).and_return(config)
    end

    subject { Phrase::Tool::Locale.send(:api_client) }

    it { should be_a Phrase::Api::Client }
    specify { subject.send(:auth_token).should == "foo" }
  end
end
