require 'spec_helper'

describe MustachedOctoTyrion do
  describe ".config/config=" do
    before :each do
      MustachedOctoTyrion.config = nil
    end

    it "loads the data from Configuration" do
      data = stub
      MustachedOctoTyrion::Configuration.should_receive(:load_config).and_return(data)
      expect(MustachedOctoTyrion.config).to eq(data)
    end

    it "memoizes the results when loading from file" do
      MustachedOctoTyrion::Configuration.should_receive(:load_config).once.and_return(stub)
      MustachedOctoTyrion.config
      MustachedOctoTyrion.config
    end

    it "allows you to assign data manually" do
      data = stub
      MustachedOctoTyrion.config = data
      expect(MustachedOctoTyrion.config).to eq(data)
    end
  end
end
