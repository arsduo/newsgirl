module Changelogger
  # Public: configuration.
  module Configuration
    # Public: an error raised when the config file is missing.
    class MissingConfigFile < Errno::ENOENT; end
    # Public: an error raised when the config file is malformed.
    class CorruptConfigFile < StandardError
      # Public: the original Psych::SyntaxError.
      attr_accessor :yaml_error

      # Public: create a new CorruptConfigFile error.
      #
      # message - the human-readable error.
      # err     - the Psych::SyntaxError
      def initialize(message, err)
        @yaml_error = err
        super(message)
      end
    end

    # Public: load configuration from the ~/.changelogger/config.yml file.
    #
    # Raises Changelogger::Configuration::MissingConfigFile if the config file
    # doesn't exist.
    # Raises Changelogger::Configuration::CorruptConfigFile if the file can't
    # be parsed.
    #
    # Returns the loaded configuration.
    def self.load_config
      YAML.load_file(config_path)
    rescue Errno::ENOENT
      raise MissingConfigFile.new(
        "The Changelogger config file couldn't be found at #{config_path}"
      )
    rescue Psych::SyntaxError => err
      raise CorruptConfigFile.new(
        "The Changelogger config file at #{config_path} is corrupt: #{err.message}",
        err
      )
    end

    # Public: the path to the configuration directory.  This will probably have
    # to change longer-term, but for now, this basic approach works.
    def self.config_path
      "~/.changelogger/config.yml"
    end
  end
end
