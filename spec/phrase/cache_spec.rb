require 'spec_helper'
require 'phrase/cache'

describe Phrase::Cache do
  let(:cache) { Phrase::Cache.new }
  let(:now) { Time.parse("2012-01-01 12:00:00") }
  let(:ten_minutes_ago) { Time.parse("2012-01-01 11:50:00") }
  let(:cache_key) { :foo }

  before(:each) do
    Phrase.stub(:cache_lifetime).and_return(300)
  end

  subject { cache }

  describe "#initialize" do
    subject { Phrase::Cache.new(lifetime: 999) }

    it { subject.lifetime.should == 999 }
  end

  describe "#cached?(cache_key)" do
    subject do
      cache_subject = nil
      Timecop.freeze(now) do
        cache_subject = cache.cached?(cache_key)
      end
      cache_subject
    end

    context "entry for that cache_key exists" do
      before(:each) do
        Timecop.freeze(now) do
          cache.set(cache_key, stub)
        end
      end

      it { should be_true }

      context "the entry has expired" do
        before(:each) do
          Timecop.freeze(ten_minutes_ago) do
            cache.set(cache_key, "bar")
          end
        end

        it { should be_false }
      end
    end

    context "no entry for that key exists" do
      it { should be_false }
    end
  end

  describe "#get(cache_key)" do
    subject { cache.get(cache_key) }

    before(:each) do
      cache.set(cache_key, "bar")
    end

    it { should == "bar" }
  end

  describe "#set(cache_key, value)" do
    subject { cache.get(cache_key) }

    before(:each) do
      cache.set(cache_key, "bar")
    end

    it { should == "bar" }
  end
end
