require 'spec_helper'

describe Parsers::DefaultParser do

  subject { Parsers::DefaultParser.new(input: file_name, fail_fast: fail_fast) }
  let (:good_data) { File.expand_path('../fixtures/files/good_data.log', __dir__) }
  let (:bad_url) { File.expand_path('../fixtures/files/bad_url.log', __dir__) }
  let (:bad_ip) { File.expand_path('../fixtures/files/bad_ip.log', __dir__) }

  let (:good_data_result) {
    [{:url=>"/help_page/1", :ip=>"202.136.230.94"},
     {:url=>"/contact", :ip=>"22.117.109.57"},
     {:url=>"/home", :ip=>"53.80.237.235"},
     {:url=>"/about/2", :ip=>"180.122.231.198"},
     {:url=>"/help_page/1", :ip=>"228.83.37.19"},
     {:url=>"/index", :ip=>"38.89.90.234"},
     {:url=>"/help_page/1", :ip=>"38.89.90.234"},
     {:url=>"/about", :ip=>"95.141.161.96"},
     {:url=>"/help_page/1", :ip=>"202.136.230.94"},
     {:url=>"/home", :ip=>"54.39.114.113"}]
  }

  let (:bad_url_result) {
    [{:url=>"/help_page/1", :ip=>"202.136.230.94"},
     {:url=>"/contact", :ip=>"22.117.109.57"},
     {:url=>"/home", :ip=>"53.80.237.235"},
     {:error=>"failed_parse", :line=>"/about////2 180.122.231.198"},
     {:url=>"/help_page/1", :ip=>"228.83.37.19"},
     {:url=>"/index", :ip=>"38.89.90.234"},
     {:url=>"/help_page/1", :ip=>"38.89.90.234"},
     {:url=>"/about", :ip=>"95.141.161.96"},
     {:url=>"/help_page/1", :ip=>"202.136.230.94"},
     {:url=>"/home", :ip=>"54.39.114.113"}]
  }

  let (:bad_ip_result) {
    [{:url=>"/help_page/1", :ip=>"202.136.230.94"},
     {:url=>"/contact", :ip=>"22.117.109.57"},
     {:url=>"/home", :ip=>"53.80.237.235"},
     {:url=>"/about/2", :ip=>"180.122.231.198"},
     {:url=>"/help_page/1", :ip=>"228.83.37.19"},
     {:url=>"/index", :ip=>"38.89.90.234"},
     {:error=>"failed_parse", :line=>"/help_page/1 9999.89.90.234"},
     {:url=>"/about", :ip=>"95.141.161.96"},
     {:url=>"/help_page/1", :ip=>"202.136.230.94"},
     {:url=>"/home", :ip=>"54.39.114.113"}]
  }

  describe '#parse' do
    context "when file is valid" do
      let (:file_name) { good_data }
      let (:fail_fast) { false }
      it "parses the file correctly" do
        expect(subject.parse).to eq(good_data_result)
      end
    end

    context "when file is invalid" do
      context "and fail fast is false for bad_url" do
        let (:file_name) { bad_url }
        let (:fail_fast) { false }
        it "parses the file correctly" do
          expect(subject.parse).to eq(bad_url_result)
        end
      end

      context "and fail fast is false for bad_ip" do
        let (:file_name) { bad_ip }
        let (:fail_fast) { false }
        it "parses the file correctly" do
          expect(subject.parse).to eq(bad_ip_result)
        end
      end

      context "and fail fast is true" do
        let (:file_name) { bad_ip }
        let (:fail_fast) { true }
        it "raises error" do
          expect{ subject.parse }.to raise_error(Parsers::Errors::FailFastError)
        end
      end
    end
  end

  describe '#open_file' do
    let (:fail_fast) { false }

    context "when file exists" do
      let (:file_name) { good_data }
      it "opens the file" do
        expect(File).to receive(:open).with(good_data, 'r')
        subject.open_file
      end
    end

    context "when file doesn't exists" do
      let (:file_name) { 'nonexistent_file' }      
      it "raises error" do
        expect{ subject.open_file }.to raise_error(Parsers::Errors::FailFastError)
      end
    end
  end

  describe '#parse_line' do
    let (:file_name) { good_data }
    context "when argument is valid" do
      let (:fail_fast) { true }
      let (:line) {'/help_page/1 202.136.230.94'}
      it { expect(subject.parse_line(line)).to eq({url: '/help_page/1', ip: '202.136.230.94'})}  
    end

    context "when argument is invalid and fail fast is true" do
      let (:fail_fast) { true }
      let (:line) {'/help_page//1 202.136.230.94'}
      it { expect{ subject.parse_line(line) }.to raise_error(Parsers::Errors::FailFastError)}  
    end

    context "when argument is invalid and fail fast is false" do
      let (:fail_fast) { false }
      let (:line) {'/help_page//1 202.136.230.94'}
      it { expect(subject.parse_line(line)).to eq({error: "failed_parse", line: line.strip})}  
    end
  end

  describe '#verify_url' do
    let (:file_name) { good_data }
    let (:fail_fast) { false }
    let(:good_url_line) {'/help_page/1'}
    let(:bad_url_line) {'/help_page//1'}
    it { expect(subject.verify_url(good_url_line)).to be_truthy }
    it { expect(subject.verify_url(bad_url_line)).to be_nil }
  end

  describe '#verify_ip' do
    let (:file_name) { good_data }
    let (:fail_fast) { false }
    let(:good_ip_line) {'202.136.230.94'}
    let(:bad_ip_line) {'202.136.230.9411'}
    it { expect(subject.verify_ip(good_ip_line)).to be_truthy }
    it { expect(subject.verify_ip(bad_ip_line)).to be_nil }
  end
end
