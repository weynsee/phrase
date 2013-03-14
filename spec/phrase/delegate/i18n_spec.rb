require 'spec_helper'
require 'phrase'
require 'phrase/delegate/i18n'

describe Phrase::Delegate::I18n do
  let(:key) { "foo.bar" }
  
  subject {
    Phrase::Delegate::I18n.new(key)
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
  
  describe "#identify_key_to_display" do
    let(:keys) { [] }
    
    before(:each) do
      subject.key = "foo.main"
      subject.fallback_keys = ["foo.fallback1", "foo.fallback2"]
      subject.stub(:find_keys_within_phrase).and_return(keys)
    end
    
    context "standard key can be found via phrase service" do
      let(:keys) { ["foo.main"] }
      
      it "should set the standard key as display key" do
        subject.send(:identify_key_to_display)
        subject.display_key.should == "foo.main"
      end
    end
    
    context "standard key cannot be found but first fallback is available" do
      let(:keys) { ["foo.fallback1", "foo.fallback2"] }
      
      it "should use the first fallback key as display key" do
        subject.send(:identify_key_to_display)
        subject.display_key.should == "foo.fallback1"
      end
    end
    
    context "standard key cannot be found but second fallback is available" do
      let(:keys) { ["foo.fallback2"] }
      
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
  
  describe "#find_keys_within_phrase(key_names)" do
    let(:key_names) { ["foo", "bar", "baz"] }
    let(:keys_from_api) { [] }
    let(:pre_cached) { [] }
    let(:pre_fetched) { [] }
    let(:delegate) { Phrase::Delegate::I18n.new(key) }
    
    subject { delegate.send(:find_keys_within_phrase, key_names) }
    
    before(:each) do
      delegate.stub(key_names_returned_from_api_for: keys_from_api)
      delegate.stub(pre_cached: pre_cached)
      delegate.stub(pre_fetched: pre_fetched)
    end
    
    it { should be_an(Array) }

    context "some keys are prefetched" do
      let(:pre_fetched) { ["foo", "bar"] }
      let(:pre_cached) { ["foo"] }
      
      context "api returns additional results" do        
        let(:keys_from_api) { ["baz"] }

        it { should == ["foo", "baz"]}
      end
      
      context "api returns no results" do
        let(:keys_from_api) { [] }
        
        it { should == ["foo"]}
      end
    end
    
    context "no keys are prefetched" do
      let(:pre_fetched) { [] }
      let(:pre_cached) { [] }
      
      context "api returns results" do        
        let(:keys_from_api) { ["baz"] }

        it { should == ["baz"]}
      end
      
      context "api returns no results" do
        let(:keys_from_api) { [] }
        
        it { should == []}
      end
    end
  end
  
  describe "#covered_by_initital_caching?(key_name)" do
    let(:key_name_to_fetch) { "simple.form" }
    
    subject { Phrase::Delegate::I18n.new(key).send(:covered_by_initial_caching?, key_name_to_fetch) }
    
    context "key starts with expression found in Phrase.cache_key_segments_initial" do
      before(:each) do
        Phrase.cache_key_segments_initial = ["simple", "bar"]
      end
      
      it { should be_true }
      
      context "is an exact match" do
        let(:key_name_to_fetch) { "simple" }
        
        it { should be_true }
      end
    end
    
    context "key does not start with expression found in Phrase.cache_key_segments_initial" do
      before(:each) do
        Phrase.cache_key_segments_initial = ["nope"]
      end
      
      it { should be_false }
    end
  end
  
  describe "#extract_fallback_keys" do
    let(:options) { {} }
    
    before(:each) do
      subject.instance_variable_set(:@options, options)      
      subject.send(:extract_fallback_keys)
    end
    
    context "when default is an array" do
      let(:options) { {:default => [:foo, :bar]} }
      
      it "should add the keys to the fallbacks" do
        subject.fallback_keys.should == ["foo", "bar"]
      end
      
      context "scope is given" do
        let(:options) { {default: [:foo, :bar], scope: "scopeee"} }
        
        it "all keys should be scoped" do
          subject.fallback_keys.should == ["scopeee.foo", "scopeee.bar"]
        end
      end
    end
    
    context "when default is a symbol" do
      let(:options) { {:default => :foo} }
      
      it "should add the key to the fallbacks" do
        subject.fallback_keys.should == ["foo"]
      end
      
      context "scope is given" do
        let(:options) { {default: :foo, scope: "scopeee"} }
        
        it "all keys should be scoped" do
          subject.fallback_keys.should == ["scopeee.foo"]
        end
      end
    end
    
    context "when no default is empty" do
      let(:options) { {} }
      
      it "should not extract a thing" do
        subject.fallback_keys.should be_empty
      end
      
      context "scope is given" do
        let(:options) { {scope: "scopeee"} }
        
        it "all keys should be scoped" do
          subject.fallback_keys.should == []
        end
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

    context "item came from simple_form" do
      it "should add the activerecord.attributes fallback as well" do
        subject.key = "simple_form.labels.users.foo"
        item = :"users.foo"
        subject.send(:process_fallback_item, item)
        subject.fallback_keys.should == ["users.foo", "activerecord.attributes.users.foo"]
      end
    end
  end
  
  describe "#decorated_key_name" do
    it "should include the phrase prefix" do
      Phrase.stub(:prefix).and_return("??")
      subject.send(:decorated_key_name).start_with?("??").should be_true
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
  
  describe "#warm_translation_key_names_cache" do
    let(:delegate) { Phrase::Delegate::I18n.new(key) }
    subject { delegate.send(:cache).get(:translation_key_names) }
    
    before(:each) do
      delegate.stub(:prefetched_key_names).and_return(["hello", "world"])
      delegate.send(:warm_translation_key_names_cache)
    end
    
    it { should be_an(Array) }
    it { should include "hello" }
    it { should include "world" }
  end
  
  describe "#prefetched_key_names" do
    let(:delegate) { Phrase::Delegate::I18n.new(key) }
    let(:initial_segments) { ["foo"] }
    let(:translate_result) { {"translate" => {}} }
    let(:api_client) { stub(translate: translate_result) }
    
    subject { delegate.send(:prefetched_key_names) }
    
    before(:each) do
      Phrase.cache_key_segments_initial = initial_segments
      delegate.stub(:api_client).and_return(api_client)
    end
    
    context "api returned a string" do
      let(:translate_result) { "lorem" }
      
      it { should include("foo") }
    end
    
    context "api returned a hash" do
      let(:translate_result) { {"bar" => "lorem"} }
      
      it { should include("foo.bar") }
    end
    
    context "api returned a nested hash" do
      let(:translate_result) { {"bar" => {"baz" => "ipsum", "def" => "lorem"}} }
      
      it { should include("foo.bar.baz") }
      it { should include("foo.bar.def") }
    end
  end
  
  describe "#key_names_from_nested(segment, data)" do
    it "returns flattened keys"
  end
end
