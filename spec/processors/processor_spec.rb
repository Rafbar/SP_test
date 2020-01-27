require 'spec_helper'

describe Processors::Processor do

  subject { Processors::Processor.new(options) }

  describe '#input' do
    context "with input param" do
      let (:options) { {silent: false, output: nil, fail_fast: false, input: 'test.log'} } 
      it { expect(subject.input).to eq('test.log') }
    end
  end

  describe '#output' do
    context "with output param" do
      let (:options) { {silent: false, output: 'test.log', fail_fast: false} } 
      it { expect(subject.output).to eq('test.log') }
      it { expect(subject.output?).to be_truthy }
    end

    context "without output param" do
      let (:options) { {silent: false, output: nil, fail_fast: false} }
      it { expect(subject.output).to be_nil }
      it { expect(subject.output?).to be_falsey }
    end
  end

  describe 'stoud_logger' do
    context "when not silent" do
      let (:options) { {silent: false, output: nil, fail_fast: false} } 
      it { expect(subject.stoud_logger).to be_an_instance_of(Loggers::StdoutLogger) }
    end

    context "when silent" do
      let (:options) { {silent: true, output: nil, fail_fast: false} } 
      it { expect(subject.stoud_logger).to be_nil }
    end
  end

  describe 'output_logger' do
    context "when format is log" do
      let (:options) { {silent: false, output: 'test.log', fail_fast: false, output_format: 'log'} } 
      it { expect(subject.output_logger).to be_an_instance_of(Loggers::DefaultLogger) }
      it { expect(subject.output_logger.file_name).to eq('test.log') }
    end

    context "when format is csv" do
      let (:options) { {silent: false, output: 'test.csv', fail_fast: false, output_format: 'csv'} } 
      it { expect(subject.output_logger).to be_an_instance_of(Loggers::CsvLogger) }
      it { expect(subject.output_logger.file_name).to eq('test.csv') }
    end

    context "when output is empty" do
      let (:options) { {silent: false, output: nil, fail_fast: false, output_format: 'log'} } 
      it { expect(subject.output_logger).to be_nil }
    end
  end

  describe 'input_logger' do
    context "when format is log" do
      let (:options) { {silent: false, output: nil, fail_fast: false, input: 'webserver.log', input_format: 'log'} } 
      it { expect(subject.input_parser).to be_an_instance_of(Parsers::DefaultParser) }
      it { expect(subject.input_parser.file_name).to eq('webserver.log') }
    end

    context "when format is csv" do
      let (:options) { {silent: false, output: nil, fail_fast: false, input: 'webserver.csv', input_format: 'csv'} } 
      it { expect(subject.input_parser).to be_an_instance_of(Parsers::CsvParser) }
      it { expect(subject.input_parser.file_name).to eq('webserver.csv') }
    end
  end
end
