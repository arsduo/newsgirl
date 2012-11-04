require 'spec_helper'

describe Changelogger do
  describe ".config/config=" do
    before :each do
      Changelogger.config = nil
    end

    it "loads the data from Configuration" do
      data = stub
      Changelogger::Configuration.should_receive(:load_config).and_return(data)
      expect(Changelogger.config).to eq(data)
    end

    it "memoizes the results when loading from file" do
      Changelogger::Configuration.should_receive(:load_config).once.and_return(stub)
      Changelogger.config
      Changelogger.config
    end

    it "allows you to assign data manually" do
      data = stub
      Changelogger.config = data
      expect(Changelogger.config).to eq(data)
    end
  end
end
