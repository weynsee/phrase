require 'spec_helper'
require 'phrase'
require 'phrase/delegate'

describe Phrase::Delegate do
  let(:key) { "foo.bar" }
  
  subject {
    Phrase::Delegate.new(key)
  }
  
  describe "#to_s" do
    it "should return the decorated key name" do
      subject.stub(:decorated_key_name).and_return("--lorem.ipsum--")
      subject.to_s.should == "--lorem.ipsum--"
    end
    
    it "should return a string" do
      subject.to_s.class.should == String
    end
  end
  
  describe "#extract_fallback_keys" do
    context "when default is an array" do
      before(:each) do
        subject.instance_variable_set(:@options, {:default => [:foo, :bar]})
      end
      
      it "should add the keys to the fallbacks" do
        subject.send(:extract_fallback_keys)
        subject.fallback_keys.should == ["foo", "bar"]
      end
    end
    
    context "when default is a symbol" do
      before(:each) do
        subject.instance_variable_set(:@options, {:default => :foo})
      end
      
      it "should add the key to the fallbacks" do
        subject.send(:extract_fallback_keys)
        subject.fallback_keys.should == ["foo"]
      end
    end
    
    context "when no default is empty" do
      before(:each) do
        subject.instance_variable_set(:@options, {})
      end
      
      it "should not extract a thing" do
        subject.send(:extract_fallback_keys)
        subject.fallback_keys.should be_empty
      end
    end
  end
  
  describe "#identify_key_to_display" do
    let(:keys) { [] }
    
    before(:each) do
      subject.key = "foo.main"
      subject.fallback_keys = ["foo.fallback1", "foo.fallback2"]
      subject.stub(:find_keys_from_service).and_return(keys)
    end
    
    context "standard key can be found via phrase service" do
      let(:keys) { [{"name" => "foo.main"}] }
      
      it "should set the standard key as display key" do
        subject.send(:identify_key_to_display)
        subject.display_key.should == "foo.main"
      end
    end
    
    context "standard key cannot be found but first fallback is available" do
      let(:keys) { [{"name" => "foo.fallback1"}, {"name" => "foo.fallback2"}] }
      
      it "should use the first fallback key as display key" do
        subject.send(:identify_key_to_display)
        subject.display_key.should == "foo.fallback1"
      end
    end
    
    context "standard key cannot be found but second fallback is available" do
      let(:keys) { [{"name" => "foo.fallback2"}] }
      
      it "should use the first fallback key as display key" do
        subject.send(:identify_key_to_display)
        subject.display_key.should == "foo.fallback2"
      end
    end
    
    context "no key can be cound via phrase service" do
      it "should set the standard key as display key" do
        subject.send(:identify_key_to_display)
        subject.display_key.should == "foo.main"
      end
    end
  end
  
  describe "#process_fallback_item" do
    context "item is a symbol" do
      it "should add an item to the fallback keys" do
        item = :foo
        subject.send(:process_fallback_item, item)
        subject.fallback_keys.should == ["foo"]
      end
    end
    
    context "item is a string" do
      it "should not add an item to the fallback keys" do
        item = "foo"
        subject.send(:process_fallback_item, item)
        subject.fallback_keys.should == []
      end      
    end
    
    context "item came from label helper" do
      it "should add the specialized activerecord.attributes fallback as well" do
        subject.key = "helpers.label.foo"
        item = :foo
        subject.send(:process_fallback_item, item)
        subject.fallback_keys.should == ["foo", "activerecord.attributes.foo"]
      end
    end
  end
  
  describe "#decorated_key_name" do
    it "should include the phrase prefix" do
      Phrase.stub(:prefix).and_return("??")
      subject.send(:decorated_key_name).starts_with?("??").should be_true
    end
    
    it "should include the phrase suffix" do
      Phrase.stub(:suffix).and_return("!!")
      subject.send(:decorated_key_name).end_with?("!!").should be_true
    end
    
    it "should include the phrase display key" do
      subject.display_key = "my.key"
      subject.send(:decorated_key_name).should include "my.key"
    end
  end
  
  describe "#api_client" do
    before(:each) do
      Phrase.auth_token = "secret999"
    end
    
    it "should return an api client" do
      subject.send(:api_client).should be_a Phrase::Api::Client
    end
    
    it "should memoize the client" do
      first_instance = subject.send(:api_client)
      second_instance = subject.send(:api_client)
      first_instance.object_id.should == second_instance.object_id
    end
    
    it "should have the auth token assigned" do
      subject.send(:api_client).auth_token.should == "secret999"
    end
  end
  
  describe "missing methods" do
    before(:each) do
      subject.stub(:translation_or_subkeys).and_return({foo: "bar"})
    end
    
    it "should respond to #each |key, value|" do
      subject.each do |key, value|
        key.should == :foo
        value.should == "bar"
      end
    end
    
    it "should respond to #each |key|" do
      subject.each do |n|
        n.should == [:foo, "bar"]
      end
    end
    
    it "should respond to #keys" do
      subject.keys.should == [:foo]
    end
    
    it "should respond to #map" do
      subject.map do |item|
        item.should == [:foo, "bar"]
      end
    end
  end
end