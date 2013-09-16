require "spec_helper"

describe Phrase::Tool::Commands::ShowVersion do
  let(:args) { [] }
  let(:options) { Phrase::Tool::Options.new(args) }

  subject { Phrase::Tool::Commands::ShowVersion.new(options, args) }

  describe "#execute!" do
    it "should display version info in stdout" do
      $stdout.should_receive(:puts).with(/phrase version/)
      command = Phrase::Tool::Commands::ShowVersion.new(options, args)
      command.execute!
    end
  end
end
