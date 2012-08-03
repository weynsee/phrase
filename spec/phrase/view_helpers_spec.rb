require 'spec_helper'
require 'phrase'
require 'phrase/view_helpers'

describe Phrase::ViewHelpers do
  before(:all) do
    class Helpers
      include Phrase::ViewHelpers
    end
  end
  
  let(:helpers) { Helpers.new }
  
  describe "#phrase_javascript" do
    context "phrase is enabled" do
      before(:each) do
        Phrase.stub(:enabled?).and_return(true)
      end
      
      it "should return a javascript block" do
        helpers.phrase_javascript.should include("<script>")
        helpers.phrase_javascript.should include("</script>")
      end

      it "should use the set host name" do
        Phrase.js_host = "faridbang.de"
        helpers.phrase_javascript.should include("faridbang.de")
      end

      it "should use https when configured" do
        Phrase.js_use_ssl = true
        helpers.phrase_javascript.should include("https")
      end

      it "should use http when configured" do
        Phrase.js_use_ssl = false
        helpers.phrase_javascript.should include("http")
        helpers.phrase_javascript.should_not include("https")
      end

      context "auth token is empty" do
        it "should use the auth token from Phrase.config" do
          Phrase.auth_token = "foobar"
          helpers.phrase_javascript.should include("foobar")
        end
      end

      context "auth token is not empty" do
        it "should include the given auth token" do
          Phrase.auth_token = "foobar"
          helpers.phrase_javascript("explicittoken").should include("explicittoken")
          helpers.phrase_javascript("explicittoken").should_not include("foobar")
        end
      end      
    end

    context "phrase is disabled" do
      before(:each) do
        Phrase.stub(:enabled?).and_return(false)
      end
      
      it "should not return a thing" do
        helpers.phrase_javascript.should == ""
      end
    end
  end
end