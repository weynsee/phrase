require 'spec_helper'

require 'phrase'
require 'phrase/delegate'

describe Phrase::Delegate do
  describe Phrase::Delegate::Base do
    subject { Phrase::Delegate::Base.new }
    
    it { should be_a_kind_of String }
  end
end