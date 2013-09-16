require "spec_helper"

describe Phrase::Tool::Commands::Tags do
  let(:args) { [] }
  let(:options) { Phrase::Tool::Options.new(args, "tags") }
  let(:config) { stub(secret: "secr3t") }
  let(:command) { Phrase::Tool::Commands::Tags.new(options, args) }

  subject { command }

  before(:each) do
    Phrase::Tool::Commands::Tags.any_instance.stub(:config).and_return(config)
    Phrase::Tool::Commands::Tags.any_instance.stub(:print_message)
    Phrase::Tool::Commands::Tags.any_instance.stub(:print_error)
  end

  describe "#list_tags" do
    let(:api_client) { stub(list_tags: [{"name" => "foo"}]) }

    before(:each) do
      subject.stub(:api_client).and_return(api_client)
    end

    specify { command.should_receive(:print_message).with("foo"); subject.send(:list_tags) }
  end
end
