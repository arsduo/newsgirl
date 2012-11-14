require 'spec_helper'

describe Newsgirl do
  describe ".config/config=" do
    before :each do
      Newsgirl.config = nil
    end

    it "loads the data from Configuration" do
      data = stub
      Newsgirl::Configuration.should_receive(:load_config).and_return(data)
      expect(Newsgirl.config).to eq(data)
    end

    it "memoizes the results when loading from file" do
      Newsgirl::Configuration.should_receive(:load_config).once.and_return(stub)
      Newsgirl.config
      Newsgirl.config
    end

    it "allows you to assign data manually" do
      data = stub
      Newsgirl.config = data
      expect(Newsgirl.config).to eq(data)
    end
  end
end
