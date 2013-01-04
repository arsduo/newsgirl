require 'spec_helper'

module Newsgirl
  describe Configuration do
    it "loads and returns the YAML file at the default location" do
      path, result = stub("path"), stub("result")
      Configuration.stub(:config_path).and_return(path)
      YAML.should_receive(:load_file).with(path).and_return(result)
      expect(Configuration.load_config).to eq(result)
    end

    it "raises MissingConfigFile if the file is missing" do
      YAML.stub(:load_file).and_raise(Errno::ENOENT.new)
      expect {
        Configuration.load_config
      }.to raise_error(Configuration::MissingConfigFile)
    end

    it "raises CorruptConfigFile if the file can't be loaded" do
      # absurdly, this seems to have different initializers in different
      # implementations
      error = Psych::SyntaxError.new("file", 1, 2, 3, "badness", stub("ctx"))

      YAML.stub(:load_file).and_raise(error)

      expect {
        Configuration.load_config
      }.to raise_error(Configuration::CorruptConfigFile)
    end
  end

  describe ".config_path" do
    it "returns the path" do
      expect(Configuration.config_path).to eq("~/.newsgirl/config.yml")
    end
  end
end

