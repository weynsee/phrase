require "spec_helper"

describe Phrase::Tool::Commands::ShowVersion do
  let(:options) { stub }

  subject { Phrase::Tool::Commands::ShowVersion.new(options) }
  
  describe "#execute!" do    
    it "should display version info in stdout" do
      $stdout.should_receive(:puts).with(/phrase version/)
      command = Phrase::Tool::Commands::ShowVersion.new(options)
      command.execute!
    end
  end
end