# frozen_string_literal: true

require 'yaml'
require 'securerandom'

module DatabaseAdapter
  # Adapter for a simple YAML-based flat file database.
  #
  # This class implements the `DatabaseAdapter::Base` interface, providing
  # CRUD operations for a flat file database using YAML.
  #
  # @see DatabaseAdapter::Base For the interface definition.
  #
  # @example Initializing the adapter
  #   adapter = DatabaseAdapter::SimpleDB.new('./path/to/db')
  #
  # @example Using the adapter
  #   adapter.create(table: 'users', attributes: { name: 'John', age: 30 })
  #   adapter.find(table: 'users', id: 'some-id')
  class SimpleDB < Base
    DB_PATH = './db/simple_db'

    # Initializes the SimpleDB adapter and ensures the database directory exists.
    #
    # @param opts [Hash] the options for initialization
    # @option opts [String] :path the database path (default: `DB_PATH`)
    # @example Initializing the adapter
    #   adapter = DatabaseAdapter::SimpleDB.new(path: './db')
    def initialize(**opts)
      validate_opts(opts, path: String)
      @db_path = opts.fetch(:path, DB_PATH)
      Dir.mkdir(@db_path) unless Dir.exist?(@db_path)
    end

    # Finds a record by its ID in the specified table.
    #
    # @param opts [Hash] the options for the method
    # @option opts [String] :table the name of the table
    # @option opts [String] :id the ID of the record
    # @raise [ArgumentError] if validation fails
    # @raise [Errno::ENOENT] if the database directory or file is inaccessible
    # @return [Hash, nil] the record as a hash or nil if not found
    # @example Finding a record
    #   adapter.find(table: 'users', id: 'some-uuid')
    def find(**opts)
      validate_opts(opts, table: String, id: String)
      load_record(**opts)
    end

    # Retrieves all records from the specified table.
    #
    # @param opts [Hash] the options for the method
    # @option opts [String] :table the name of the table
    # @raise [ArgumentError] if validation fails
    # @raise [Errno::ENOENT] if the database directory or table is inaccessible
    # @return [Array<Hash>] an array of hashes representing records
    # @example Retrieving all records
    #   adapter.all(table: 'users')
    def all(**opts)
      validate_opts(opts, table: String)
      load_all_records(opts[:table])
    end

    # Creates a new record in the specified table.
    #
    # @param opts [Hash] the options for the method
    # @option opts [String] :table the name of the table
    # @option opts [Hash] :attributes the attributes for the new record
    # @raise [ArgumentError] if validation fails
    # @raise [Errno::ENOENT] if the database directory or table is inaccessible
    # @return [String] the ID of the created record
    # @example Creating a record
    #   adapter.create(table: 'users', attributes: { name: 'John', age: 30 })
    def create(**opts)
      validate_opts(opts, table: String, attributes: Hash)
      id = SecureRandom.uuid
      write_to_file(table: opts[:table], id: id, attributes: opts[:attributes])
      id
    end

    # Updates a record by its ID in the specified table.
    #
    # @param opts [Hash] the options for the method
    # @option opts [String] :table the name of the table
    # @option opts [String] :id the ID of the record
    # @option opts [Hash] :attributes the updated attributes
    # @raise [ArgumentError] if validation fails
    # @raise [Errno::ENOENT] if the database directory or table is inaccessible
    # @return [void]
    # @example Updating a record
    #   adapter.update(table: 'users', id: 'some-uuid', attributes: { age: 31 })
    def update(**opts)
      validate_opts(opts, table: String, id: String, attributes: Hash)
      write_to_file(**opts)
    end

    # Deletes a record by its ID in the specified table.
    #
    # @param opts [Hash] the options for the method
    # @option opts [String] :table the name of the table
    # @option opts [String] :id the ID of the record
    # @raise [ArgumentError] if validation fails
    # @raise [Errno::ENOENT] if the database directory or file is inaccessible
    # @return [void]
    # @example Deleting a record
    #   adapter.delete(table: 'users', id: 'some-uuid')
    def delete(**opts)
      validate_opts(opts, table: String, id: String)
      file = file_path(opts[:table], opts[:id])
      File.delete(file) if File.exist?(file)
    end

    private

    # Validates the options hash for required keys and types.
    #
    # @param opts [Hash] the options hash to validate
    # @param required_keys [Hash] a hash of required keys and their expected types
    # @raise [ArgumentError] if validation fails
    # @return [void]
    def validate_opts(opts, required_keys)
      raise ArgumentError, 'opts must be a Hash' unless opts.is_a?(Hash)

      required_keys.each do |key, type|
        raise ArgumentError, "#{key} must be a #{type}" unless opts[key].is_a?(type)
      end
    end

    # Returns the path to the directory for the specified table.
    #
    # If the directory does not exist, it will be created automatically.
    #
    # @param table [String] the name of the table
    # @return [String] the path to the table directory
    def table_path(table)
      Dir.mkdir(@db_path) unless Dir.exist?(@db_path) # Убедиться, что базовая директория существует
      File.join(@db_path, table).tap { |p| Dir.mkdir(p) unless Dir.exist?(p) }
    end

    # Returns the path to the file for the specified record.
    # @param table [String] the name of the table
    # @param id [String] the ID of the record
    # @return [String] the path to the record file
    def file_path(table, id) = File.join(table_path(table), id)

    # Writes attributes to a file in the specified table.
    # @param table [String] the name of the table
    # @param id [String] the ID of the record
    # @param attributes [Hash] the attributes to write
    # @return [void]
    def write_to_file(table:, id:, attributes:) =
      File.write(file_path(table, id), YAML.dump(attributes.transform_keys(&:to_sym)))

    # Loads a record from the specified table by its ID.
    # @param table [String] the name of the table
    # @param id [String] the ID of the record
    # @return [Hash, nil] the record as a hash or nil if not found
    def load_record(table:, id:)
      file = file_path(table, id)
      return nil unless File.exist?(file)

      YAML.load_file(file).transform_keys(&:to_sym).merge(id: id)
    end

    # Loads all records from the specified table.
    # @param table [String] the name of the table
    # @return [Array<Hash>] an array of hashes representing records
    def load_all_records(table)
      Dir[File.join(table_path(table), '*')].map do |file|
        id = File.basename(file)
        YAML.load_file(file).transform_keys(&:to_sym).merge(id: id)
      end
    end
  end
end