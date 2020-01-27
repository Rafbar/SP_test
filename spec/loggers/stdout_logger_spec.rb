require 'spec_helper'

describe Loggers::StdoutLogger do

  subject { Loggers::StdoutLogger.new }
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

  describe 'log' do
    it "logs result data in blocks" do
      expect($stdout).to receive(:puts).with("test")
      expect($stdout).to receive(:puts).with("url: 1, value: 1")
      expect($stdout).to receive(:puts).with("url: 2, value: 2")
      expect($stdout).to receive(:puts).with("test2")
      expect($stdout).to receive(:puts).with("url: 3, value: 3")
      expect($stdout).to receive(:puts).with("url: 4, value: 4")
      subject.log(result)
    end
  end

  describe 'log_block' do
    it 'logs given data block' do
      expect($stdout).to receive(:puts).with("test")
      expect($stdout).to receive(:puts).with("url: 1, value: 1")
      expect($stdout).to receive(:puts).with("url: 2, value: 2")
      subject.log_block(result.keys.first, result.values.first)
    end
  end
end
