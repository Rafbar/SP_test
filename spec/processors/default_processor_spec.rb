require 'spec_helper'

describe Processors::DefaultProcessor do

  subject { Processors::DefaultProcessor.new(options) }
  let (:good_data) {
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
  let (:bad_data) {
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
  let (:options) { {silent: false, output: "undefined", fail_fast: false, input: 'test.log'} }

  let (:good_data_result) {
    {"All visits"=>
      [["/help_page/1", 4],
       ["/home", 2],
       ["/about", 1],
       ["/index", 1],
       ["/about/2", 1],
       ["/contact", 1]],
     "Unique visits"=>
      [["/help_page/1", 3],
       ["/home", 2],
       ["/about", 1],
       ["/index", 1],
       ["/about/2", 1],
       ["/contact", 1]],
     "Errors"=>[]}
  }

  let (:bad_data_result) {
    {"All visits"=>
      [["/help_page/1", 4],
       ["/home", 2],
       ["/about", 1],
       ["/index", 1],
       ["/contact", 1]],
     "Unique visits"=>
      [["/help_page/1", 3],
       ["/home", 2],
       ["/about", 1],
       ["/index", 1],
       ["/contact", 1]],
     "Errors"=>[["failed_parse", "/about////2 180.122.231.198"]]}
      }

  describe '#process_input' do
    context "with good parsed input" do
      it { expect(subject.process_input(good_data)).to eq(good_data_result) }
    end

    context "with bad parsed input" do
      it { expect(subject.process_input(bad_data)).to eq(bad_data_result) }
    end
  end

  describe '#unique_visits' do
    context "with duplicate ip" do
      let (:duplicate) { {"/help_page/1"=>["202.136.230.94", "228.83.37.19", "38.89.90.234", "202.136.230.94"]} } 
      it { expect(subject.unique_visits(duplicate)).to eq([["/help_page/1", 3]]) }
    end
  end

  describe '#all_visits' do
    context "with duplicate ip" do
      let (:duplicate) { {"/help_page/1"=>["202.136.230.94", "228.83.37.19", "38.89.90.234", "202.136.230.94"]} } 
      it { expect(subject.all_visits(duplicate)).to eq([["/help_page/1", 4]]) }
    end
  end
end
