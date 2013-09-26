require "spec_helper"

describe Phrase::Tool::Commands::Base do
  let(:options) { stub(set?: false) }
  let(:config) { stub(secret: "secret") }
  subject { Phrase::Tool::Commands::Base.new(options) }

  describe "#execute!" do
    it "should raise an error" do
      lambda {
        subject.execute!
      }.should raise_error(/not implemented/)
    end
  end

  describe "#api_client" do
    subject { Phrase::Tool::Commands::Base.new(options).send(:api_client) }

    before(:each) do
      Phrase::Tool::Commands::Base.any_instance.stub(:config).and_return(config)
    end

    it { should be_a(Phrase::Api::Client) }
  end

  describe "#config" do
    subject { Phrase::Tool::Commands::Base.new(options).send(:config) }

    it { should be_a(Phrase::Tool::Config) }
  end

  describe "#print_error" do
    let(:message) { "Hello Error!" }

    it "should print a message to stderr" do
      $stderr.should_receive(:puts).with(/Hello Error/)
      subject.send(:print_error, message)
    end
  end

  describe "#print_message" do
    let(:message) { "Hello World!" }

    it "should print a message to stdout" do
      $stdout.should_receive(:puts).with(message)
      subject.send(:print_message, message)
    end
  end
end
