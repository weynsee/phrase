require 'spec_helper'
require 'phrase/hash_flattener'

describe Phrase::HashFlattener do
  describe "#flatten(hash, escape, previous_key=nil, &block)" do
    subject do
      keys = []
      Phrase::HashFlattener.flatten(hash, escape) do |key, value|
        keys << key
      end
      keys
    end

    let(:hash) { {"foo" => "bar"} }
    let(:escape) { "." }

    it { should eql [:foo] }
  end
end
