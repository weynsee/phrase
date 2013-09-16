require 'spec_helper'

describe Phrase do
  describe "#self.enabled?" do
    it "should return true if phrase is enabled" do
      Phrase.stub(:enabled).and_return(true)
      Phrase.enabled?.should be_true
    end

    it "should return false if phrase is not enabled" do
      Phrase.stub(:enabled).and_return(false)
      Phrase.enabled?.should be_false
    end
  end

  describe "#self.disabled?" do
    it "should return true if phrase is disabled" do
      Phrase.stub(:enabled).and_return(false)
      Phrase.disabled?.should be_true
    end

    it "should return false if phrase is not disabled" do
      Phrase.stub(:enabled).and_return(true)
      Phrase.disabled?.should be_false
    end
  end

  describe "self.configure" do
    before(:each) do
      Phrase.configure do |config|
        config.auth_token = "some new auth token"
        config.prefix = "my prefix"
        config.suffix = "my suffix"
      end
    end

    specify { Phrase.auth_token.should eql("some new auth token") }
    specify { Phrase.prefix.should eql("my prefix") }
    specify { Phrase.suffix.should eql("my suffix") }
  end
end
