require 'spec_helper'

describe Phrase::Tool::Config do
  describe '#overwrite!' do
    let(:config) { Phrase::Tool::Config.new }
    subject { config.secret }

    before(:each) do
      config.stub(:save_config!)
      config.secret = 'my secret'
    end

    describe 'not overwritten' do
      it { should == 'my secret' }
    end

    describe 'overwritten' do
      before { config.overwrite!('secret', 'my special secret') }
      it { should == 'my special secret' }
    end
  end
end
