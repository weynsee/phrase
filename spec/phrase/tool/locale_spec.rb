require 'spec_helper'

describe Phrase::Tool::Locale do
  let(:attrs) { {id: 42, name: "fr", code: "fr-FR", is_default: true} }
  
  subject { Phrase::Tool::Locale.new(attrs) } 
  
  it { subject.id.should eql(42) }
  it { subject.name.should eql("fr") }
  it { subject.code.should eql("fr-FR") }
  it { subject.default?.should be_true }
end