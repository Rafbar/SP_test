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

  describe '#stdout_logger' do
    context "when not silent" do
      let (:options) { {silent: false, output: nil, fail_fast: false} } 
      it { expect(subject.stdout_logger).to be_an_instance_of(Loggers::StdoutLogger) }
    end

    context "when silent" do
      let (:options) { {silent: true, output: nil, fail_fast: false} } 
      it { expect(subject.stdout_logger).to be_nil }
    end
  end

  describe '#output_logger' do
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

  describe '#input_logger' do
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

  describe '#run' do
    context "with no errors" do
      before do
        allow_any_instance_of(Parsers::DefaultParser).to receive(:parse).and_return({test: 'test'})
        allow_any_instance_of(Loggers::DefaultLogger).to receive(:log).and_return(true)
        allow_any_instance_of(Loggers::StdoutLogger).to receive(:log).and_return(true)
      end

      context "and an output file" do
        let (:options) { {silent: false, output: 'output.log', fail_fast: false, input_format: 'log', output_format: 'log'} }

        it "processes the file and logs the output to file and stdout" do
          expect_any_instance_of(Parsers::DefaultParser).to receive(:parse)
          expect_any_instance_of(Loggers::DefaultLogger).to receive(:log)
          expect_any_instance_of(Loggers::StdoutLogger).to receive(:log)
          subject.run
        end
      end

      context "and no output file" do
        let (:options) { {silent: false, output: nil, fail_fast: false, input_format: 'log', output_format: 'log'} }

        it "processes the file and logs the output to stdout" do
          expect_any_instance_of(Parsers::DefaultParser).to receive(:parse)
          expect_any_instance_of(Loggers::DefaultLogger).not_to receive(:log)
          expect_any_instance_of(Loggers::StdoutLogger).to receive(:log)
          subject.run
        end
      end

      context "when silent" do
        let (:options) { {silent: true, output: 'output.log', fail_fast: false, input_format: 'log', output_format: 'log'} }

        it "processes the file and logs the output to file" do
          expect_any_instance_of(Parsers::DefaultParser).to receive(:parse)
          expect_any_instance_of(Loggers::DefaultLogger).to receive(:log)
          expect_any_instance_of(Loggers::StdoutLogger).not_to receive(:log)
          subject.run
        end
      end
    end

    context "with fail_fast error" do
      before do
        allow_any_instance_of(Parsers::DefaultParser).to receive(:parse).and_raise(Parsers::Errors::FailFastError.new('test error'))
      end
      let (:options) { {silent: false, output: nil, fail_fast: false, input_format: 'log', output_format: 'log'} }

      it "stops processing and puts an error message to console" do
        expect_any_instance_of(Parsers::DefaultParser).to receive(:parse)
        expect_any_instance_of(Loggers::DefaultLogger).not_to receive(:log)
        expect_any_instance_of(Loggers::StdoutLogger).not_to receive(:log)
        expect{subject.run}.to output("Parser failed fast on test error\n").to_stdout
      end
    end
  end
end
