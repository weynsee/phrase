require 'spec_helper'
require 'phrase'
require 'phrase/backend/phrase_service'

describe Phrase::Backend::PhraseService do
  
  let(:phrase_service){ Phrase::Backend::PhraseService.new }
  
  describe "#translate" do
    let(:key_name) { "foo.bar" }
    let(:i18n_translation) { stub }
    let(:key_is_blacklisted){ false }
    let(:key_is_ignored) { false }
    
    before do
      Phrase.prefix = "{{__"
      Phrase.suffix = "__}}"
      I18n.stub(:translate_without_phrase).with(key_name).and_return(i18n_translation)
      phrase_service.stub(:has_blacklist_entry_for_key?){ key_is_blacklisted }
      phrase_service.stub(:key_is_ignored?) { key_is_ignored }
    end
    
    subject { phrase_service.translate(*args) }
    
    context "phrase is enabled" do
      before do
        Phrase.stub(:disabled?){ false }
      end
      
      context "key is blacklisted" do
        let(:args){ [key_name] }
        let(:key_is_blacklisted){ true }
           
        it { should eql i18n_translation }
      end

      context "key is ignored" do
        let(:args) { [key_name] }
        let(:key_is_ignored) { true }
           
        it { should eql i18n_translation }
      end
      
      context "resolve: false given as argument" do
        let(:args){ [key_name, resolve: false] }
        before do
          I18n.stub(:translate_without_phrase).with(key_name, resolve: false).and_return(i18n_translation)
        end

        it { should eql i18n_translation }
      end

      context "resolve: true given as argument" do
        let(:args){ [key_name, resolve: true] }

        it { should be_a String }
        it { should eql '{{__phrase_foo.bar__}}' }
      end

      context "key is not blacklisted" do
        let(:args){ [key_name] }
        let(:key_is_blacklisted){ false }
        
        it { should be_a Phrase::Delegate::I18n }
        it { should eql '{{__phrase_foo.bar__}}' }
      end
      
      describe "different arguments given" do
        context "default array given" do
          let(:args){ [:key, { :default => [:first_fallback, :second_fallback] }] }
          
          it { 
            pending "figure out a sane way to test fallback order" 
            should eql '{{__phrase_key__}}'
          }
        end

        context "default string given" do
          let(:args){ [:key, { :default => 'first fallback' }] }
          
          it { should eql '{{__phrase_key__}}' }
        end

        context "scope array given" do
          let(:context_key_translation){ stub }
          let(:args){ [:key, { :scope => [:context] }] }

          it { should eql '{{__phrase_context.key__}}' }
        end

      end
    end
    
    context "phrase is disabled" do
      let(:args){ [key_name] }
      
      before do
        Phrase.stub(:disabled?){ true }
      end
      
      it { should eql i18n_translation }

      context "given arguments other than key_name" do
        let(:args){ [key_name, locale: :ru] }
        let(:ru_translation){ stub }
        
        before do
          I18n.stub(:translate_without_phrase).with(key_name, locale: :ru){ ru_translation }
        end
        
        it { should eql ru_translation }
      end

      describe "different arguments given" do 
        before do
          I18n.unstub(:translate_without_phrase)
        end

        context "default array given" do
          let(:args){ [:key, { :default => [:first_fallback, :second_fallback] }] }
          
          it { subject.should eql "translation missing: en.key" }
        end

        context "default string given" do
          let(:args){ [:key, { :default => 'first fallback' }] }
          
          it { should eql 'first fallback' }
        end

        context "scope array given" do
          let(:context_key_translation){ stub }
          let(:args){ [:key, { :scope => [:context] }] }

          it { subject.should eql "translation missing: en.context.key" }
        end
      end
    end
  end
  
  describe "#has_blacklist_entry_for_key?(key)" do
    let(:key){ 'foo.blacklisted' }
    subject { phrase_service.send(:has_blacklist_entry_for_key?, key) }

    before do
      phrase_service.stub(:blacklisted_keys){ blacklisted_keys }
    end

    context "blacklisted_keys contain key" do
      let(:blacklisted_keys){ [key] }
      it { should be_true }
    end
    
    context "key is blacklisted (using wildcards)" do
      let(:blacklisted_keys){ ["foo.black*"] }
      it { should be_true }
    end
    
    context "if no blacklisted_keys" do
      let(:blacklisted_keys){ [] }
      it { should be_false }
    end
  end

  describe "#key_is_ignored?(key)" do
    let(:key) { 'foo.ignored' }

    subject { phrase_service.send(:key_is_ignored?, key) }

    before(:each) do
      Phrase.ignored_keys = ignored_keys
    end

    context "blacklisted_keys contain key" do
      let(:ignored_keys) { ["foo.ignored"] }

      it { should be_true }
    end
    
    context "key is ignores (using wildcards)" do
      let(:ignored_keys) { ["foo.*"] }

      it { should be_true }
    end
    
    context "if no keys are ignored" do
      let(:ignored_keys) { [] }

      it { should be_false }
    end
  end
  
  describe "#blacklisted_keys" do
    subject { phrase_service.send(:blacklisted_keys) }

    before do
      phrase_service.stub(:api_client){ stub(fetch_blacklisted_keys: ["lorem"]) }
    end
    
    it { should eql ["lorem"] }
     
    describe "memoizing the blacklisted_keys" do
      it { 
        old_id = phrase_service.send(:blacklisted_keys).object_id
        phrase_service.stub(:api_client){ stub(fetch_blacklisted_keys: ["ipsum"]) }
        old_id.should eql subject.object_id
      }
    end
  end
  
  describe "#api_client" do
    let(:api_client_method_call){ phrase_service.send(:api_client) }
    subject { api_client_method_call }

    before do
      Phrase.auth_token = "secret999"
    end
    
    it { should be_a Phrase::Api::Client }
    
    describe "returned api client's auth token" do
      subject { api_client_method_call.auth_token }
      it { should eql "secret999" }
    end
  end
end
