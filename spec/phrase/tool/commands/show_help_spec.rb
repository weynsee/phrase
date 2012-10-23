require "spec_helper"

describe Phrase::Tool::Commands::ShowHelp do
  let(:args) { [] }
  let(:options) { Phrase::Tool::Options.new(args) }

  subject { Phrase::Tool::Commands::ShowHelp.new(options, args) }
  
  describe "#execute!" do    
    it "should write help text to stdout" do
      $stdout.should_receive(:puts).with(/phrase <command>/)
      command = Phrase::Tool::Commands::ShowHelp.new(options, args)
      command.execute!
    end
  end
end