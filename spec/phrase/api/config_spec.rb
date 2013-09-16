require 'spec_helper'
require 'phrase/api/client'
require 'phrase/api/config'

describe Phrase::Api::Config do
  describe "#self.api_port" do
    before(:all) do
      @existing_api_port = ENV["PHRASE_API_PORT"]
    end

    after(:all) do
      ENV["PHRASE_API_PORT"] = @existing_api_port
    end

    context "port is set via env" do
      it "should return the env value" do
        ENV["PHRASE_API_PORT"] = "0815"
        Phrase::Api::Config.api_port.should == "0815"
      end
    end

    context "port is not set explicitely" do
      it "should return 443 as default" do
        ENV["PHRASE_API_PORT"] = nil
        Phrase::Api::Config.api_port.should == "443"
      end
    end
  end

  describe "#self.api_host" do
    before(:all) do
      @existing_api_host = ENV["PHRASE_API_HOST"]
    end

    after(:all) do
      ENV["PHRASE_API_HOST"] = @existing_api_host
    end

    context "host is set via env" do
      it "should return the env value" do
        ENV["PHRASE_API_HOST"] = "dynport.de"
        Phrase::Api::Config.api_host.should == "dynport.de"
      end
    end

    context "port is not set explicitely" do
      it "should return phraseapp.com as default" do
        ENV["PHRASE_API_HOST"] = nil
        Phrase::Api::Config.api_host.should == "phraseapp.com"
      end
    end
  end

  describe "#self.api_use_ssl?" do
    before(:all) do
      @existing_api_use_ssl = ENV["PHRASE_API_USE_SSL"]
    end

    after(:all) do
      ENV["PHRASE_API_USE_SSL"] = @existing_api_use_ssl
    end

    context "use_ssl is set via env" do
      it "should return the env value" do
        ENV["PHRASE_API_USE_SSL"] = "0"
        Phrase::Api::Config.api_use_ssl?.should be_false
      end
    end

    context "use_ssl is not set explicitely" do
      it "should return true as default" do
        ENV["PHRASE_API_USE_SSL"] = nil
        Phrase::Api::Config.api_use_ssl?.should be_true
      end
    end
  end

  describe "#self.api_path_prefix" do
    before(:all) do
      @existing_api_version = Phrase::API_VERSION
    end

    after(:all) do
      Phrase.send(:remove_const, "API_VERSION")
      Phrase.const_set("API_VERSION", @existing_api_version)
    end

    it "returns the path prefix containing the api version number" do
      Phrase.send(:remove_const, "API_VERSION")
      Phrase.const_set("API_VERSION", "v8")
      Phrase::Api::Config.api_path_prefix.should == "/api/v8"
    end
  end

  describe "#self.api_max_retries" do
    before(:all) do
      @existing_api_max_retries = ENV["PHRASE_API_MAX_RETRIES"]
    end

    after(:all) do
      ENV["PHRASE_API_MAX_RETRIES"] = @existing_api_max_retries
    end

    context "max_retries is set via env" do
      it "should return the env value" do
        ENV["PHRASE_API_MAX_RETRIES"] = "5"
        Phrase::Api::Config.api_max_retries.should == 5
      end
    end

    context "max_retries is not set explicitely" do
      it "should return 1 as default" do
        ENV["PHRASE_API_MAX_RETRIES"] = nil
        Phrase::Api::Config.api_max_retries.should == 3
      end
    end
  end

  describe "#self.skip_ssl_validation" do
    before(:all) do
      @existing_skip_ssl_validation = ENV["PHRASE_API_SKIP_SSL_VALIDATION"]
    end

    after(:all) do
      ENV["PHRASE_API_SKIP_SSL_VALIDATION"] = @existing_skip_ssl_validation
    end

    context "skip_ssl is set via env" do
      it "should return the env value" do
        ENV["PHRASE_API_SKIP_SSL_VALIDATION"] = "1"
        Phrase::Api::Config.skip_ssl_validation?.should be_true
      end
    end

    context "skip_ssl is not set" do
      it "should return false as default" do
        ENV["PHRASE_API_SKIP_SSL_VALIDATION"] = nil
        Phrase::Api::Config.skip_ssl_validation?.should be_false
      end
    end
  end
end
