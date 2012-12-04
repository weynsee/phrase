require 'spec_helper'

require 'phrase'
require 'phrase/delegate'

describe Phrase::Delegate::FastGettext do
  let(:key) { "lorem.ipsum" }
  
  describe "#to_s" do
    subject { Phrase::Delegate::FastGettext.new(key).to_s }
    
    it { should eql("{{__phrase_lorem.ipsum__}}")}
  end
end