require "spec_helper"

describe Phrase::Tool::EncodingDetector do
  describe "#self.file_seems_to_be_utf16?(file)" do
    subject { Phrase::Tool::EncodingDetector.file_seems_to_be_utf16?(file) }
     
    context "given file is utf8" do
      let(:file) { "./spec/fixtures/edge/utf8_file.strings" }
      
      it { should be_false }
    end
    
    context "given file is empty" do
      let(:file) { "./spec/fixtures/edge/empty.strings" }
      
      it { should be_false }
    end
    
    context "given file is utf16LE" do
      let(:file) { "./spec/fixtures/edge/utf16_le_ios_file.strings" }
      
      it { should be_true }
    end
    
    context "given file is utf16BE" do
      let(:file) { "./spec/fixtures/edge/utf16_be_ios_file.strings" }
      
      it { should be_true }
    end
  end
  
  describe "#self.file_seems_to_be_utf16_be?(file)" do
    subject { Phrase::Tool::EncodingDetector.file_seems_to_be_utf16_be?(file) }
     
    context "given file is utf8" do
      let(:file) { "./spec/fixtures/edge/utf8_file.strings" }
      
      it { should be_false }
    end
    
    context "given file is empty" do
      let(:file) { "./spec/fixtures/edge/empty.strings" }
      
      it { should be_false }
    end
    
    context "given file is utf16LE" do
      let(:file) { "./spec/fixtures/edge/utf16_le_ios_file.strings" }
      
      it { should be_false }
    end
    
    context "given file is utf16BE" do
      let(:file) { "./spec/fixtures/edge/utf16_be_ios_file.strings" }
      
      it { should be_true }
    end
  end
  
  describe "#self.file_seems_to_be_utf16_le?(file)" do
    subject { Phrase::Tool::EncodingDetector.file_seems_to_be_utf16_le?(file) }
     
    context "given file is utf8" do
      let(:file) { "./spec/fixtures/edge/utf8_file.strings" }
      
      it { should be_false }
    end
    
    context "given file is empty" do
      let(:file) { "./spec/fixtures/edge/empty.strings" }
      
      it { should be_false }
    end
    
    context "given file is utf16LE" do
      let(:file) { "./spec/fixtures/edge/utf16_le_ios_file.strings" }
      
      it { should be_true }
    end
    
    context "given file is utf16BE" do
      let(:file) { "./spec/fixtures/edge/utf16_be_ios_file.strings" }
      
      it { should be_false }
    end
  end
end