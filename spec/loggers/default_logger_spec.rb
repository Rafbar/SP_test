require 'spec_helper'

describe Loggers::DefaultLogger do

  subject { Loggers::DefaultLogger.new }
  let(:result) {{
    'test' => [
      ['1','1'],
      ['2','2']
    ],
    'test2' => [
      ['3','3'],
      ['4','4']
    ]}
  }
  let(:file_instance){ double("File") }

  before do
    allow(File).to receive(:open).and_return(file_instance)
    allow(file_instance).to receive(:write)
    allow(file_instance).to receive(:close)
  end

  describe 'log' do
    it "logs result data in blocks" do
      expect(file_instance).to receive(:write).with("test\n")
      expect(file_instance).to receive(:write).with("url: 1, value: 1\n")
      expect(file_instance).to receive(:write).with("url: 2, value: 2\n")
      expect(file_instance).to receive(:write).with("test2\n")
      expect(file_instance).to receive(:write).with("url: 3, value: 3\n")
      expect(file_instance).to receive(:write).with("url: 4, value: 4\n")
      subject.log(result)
    end
  end

  describe 'log_block' do
    it 'logs given data block' do
      expect(file_instance).to receive(:write).with("test\n")
      expect(file_instance).to receive(:write).with("url: 1, value: 1\n")
      expect(file_instance).to receive(:write).with("url: 2, value: 2\n")
      subject.open_file
      subject.log_block(result.keys.first, result.values.first)
    end
  end  
end
