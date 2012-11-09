require "mustached_octo_tyrion/version"
require "mustached_octo_tyrion/configuration"

module MustachedOctoTyrion

  # Public: load the configuration from memory (if already assigned) or through
  # the Configuration object, which loads it from file (and memoizes the
  # result).
  #
  # Returns a configuration object.
  def self.config
    @config ||= Configuration.load_config
  end

  # Public manually set the configuration to a different value.
  #
  # config_data - provide already-compiled configuration data rather than
  #               loading from file.
  #
  # Returns the new configuration.
  def self.config=(data)
    @config = data
  end
  # Your code goes here...
end
