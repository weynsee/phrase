require "spec_helper"

describe Phrase::Tool::Commands::ShowHelp do
  let(:options) { stub }

  subject { Phrase::Tool::Commands::ShowHelp.new(options) }
  
  describe "#execute!" do    
    it "should write help text to stdout" do
      $stdout.should_receive(:puts).with(/phrase <command>/)
      command = Phrase::Tool::Commands::ShowHelp.new(options)
      command.execute!
    end
  end
end