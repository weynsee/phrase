require 'spec_helper'

describe Phrase::Tool::Options do
  describe "#get" do
    context "init command" do
      let(:command) { "init" }
      let(:args) { ["--secret=foobar", "--default-locale=hu"] }
      
      describe "the secret" do
        subject { Phrase::Tool::Options.new(args, command).get(:secret) }
        
        it { should eql("foobar") }
      end
      
      describe "the default locale" do
        subject { Phrase::Tool::Options.new(args, command).get(:default_locale) }
        
        it { should eql("hu") }
      end
    end
    
    context "push command" do
      let(:command) { "push" }
      let(:args) { ["--tags=lorem,ipsum", "--recursive"] }
      
      describe "tags" do
        subject { Phrase::Tool::Options.new(args, command).get(:tags) }
        
        it { should eql(["lorem", "ipsum"]) }
      end
      
      describe "recursive" do
        subject { Phrase::Tool::Options.new(args, command).get(:recursive) }
        
        it { should be_true }
      end
    end
    
    context "pull command" do
      let(:command) { "pull" }
      let(:args) { ["--format=po"] }
      
      describe "format" do
        subject { Phrase::Tool::Options.new(args, command).get(:format) }
        
        it { should eql "po" }
      end
    end
    
    context "no command" do
      let(:command) { nil }
      let(:args) { ["-h", "-v"] }
      
      describe "help param" do
        subject { Phrase::Tool::Options.new(args, command).get(:help) }
        
        it { should be_true }
      end
      
      describe "version param" do
        subject { Phrase::Tool::Options.new(args, command).get(:version) }
        
        it { should be_true }
      end
    end
  end
  
  describe "#options" do
    subject { Phrase::Tool::Options.new([]).send(:options) }
    
    it { should be_a OptionParser }
  end
end