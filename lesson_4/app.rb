# frozen_string_literal: true

require 'yaml'

require_relative '../lib/cui'
require_relative '../lib/database_adapter'
require_relative 'lib/railroad'
require_relative 'app/model'
require_relative 'app/view'
require_relative 'app/controller'

module Lesson4
  # Represents the Railroad app.
  # Main application module, containing all starting settings and providing access
  # to localization, directory configuration, and database adapter initialization.
  module App
    # Custom error for handling localization file issues.
    class LocalizationError < StandardError; end

    # Loads the localization file and returns its content as a hash with symbolized keys.
    #
    # @raise [LocalizationError] if the localization file is missing or contains syntax errors.
    # @return [Hash<Symbol, Object>] the localization data.
    # @example Accessing localization data
    #   Lesson4::App.l10n[:some_key]
    def self.l10n
      YAML.load_file("#{__dir__}/config/l10n.yml", symbolize_names: true)
    rescue Errno::ENOENT, Psych::SyntaxError => e
      raise LocalizationError, "Localization file error: #{e.message}"
    end

    # Returns the directory path of the application.
    #
    # @return [String, nil] the directory path.
    # @example Retrieving the application directory
    #   Lesson4::App.dir # => "/path/to/lesson_4"
    def self.dir = __dir__

    # Initializes and returns the database adapter instance.
    #
    # @return [DatabaseAdapter::SimpleDB] the database adapter instance.
    # @example Using the database adapter
    #   Lesson4::App.db_adapter.create(table: 'test', attributes: { name: 'test' })
    def self.db_adapter = DatabaseAdapter::SimpleDB.new(path: "#{dir}/db/simple_db")
  end
end
