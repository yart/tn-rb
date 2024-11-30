# frozen_string_literal: true

module Lesson4
  module App
    # Manages application-wide configurations.
    class Config
      class ConfigurationError < StandardError; end

      class << self
        attr_writer :db_adapter, :l10n_path, :routes_path

        # Configures the application settings using a block.
        #
        # @yieldparam config [Config] the configuration instance
        def configure
          yield self
        end

        # Returns the configured database adapter.
        #
        # @return [Object] the database adapter
        # @raise [ConfigurationError] if not configured
        def db_adapter
          return @db_adapter unless @db_adapter.nil?

          raise ConfigurationError, 'db_adapter is not configured'
        end

        # Returns the configured localization path.
        #
        # @return [String] the localization file path
        # @raise [ConfigurationError] if not configured
        def l10n_path
          return @l10n_path unless @l10n_path.nil?

          raise ConfigurationError, 'l10n_path is not configured'
        end

        # Returns the configured routes path.
        #
        # @return [String] the routes file path
        # @raise [ConfigurationError] if not configured
        def routes_path
          return @routes_path unless @routes_path.nil?

          raise ConfigurationError, 'routes_path is not configured'
        end
      end
    end
  end
end
