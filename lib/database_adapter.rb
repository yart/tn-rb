# frozen_string_literal: true

module DatabaseAdapter
  # Abstract base class for database adapters.
  #
  # This class provides an interface for CRUD operations on database tables.
  # Subclasses must implement all defined methods to provide specific functionality.
  #
  # @abstract This class is meant to be subclassed and cannot be used directly.
  # @see DatabaseAdapter::SimpleDB Example implementation using YAML-based storage.
  #
  # @example Defining a custom adapter
  #   class MyAdapter < DatabaseAdapter::Base
  #     def find(table:, id:)
  #       # Implementation for finding a record by ID
  #     end
  #
  #     def all(table:)
  #       # Implementation for retrieving all records
  #     end
  #
  #     def create(table:, attributes:)
  #       # Implementation for creating a record
  #     end
  #
  #     def update(table:, id:, attributes:)
  #       # Implementation for updating a record
  #     end
  #
  #     def delete(table:, id:)
  #       # Implementation for deleting a record
  #     end
  #   end
  class Base
    # Finds a record by its ID in the specified table.
    #
    # @param table [String] the name of the table
    # @param id [String] the ID of the record
    # @raise [NotImplementedError] if the method is not implemented in a subclass
    # @return [Hash, nil] the record as a hash or nil if not found
    def find(table:, id:)
      raise NotImplementedError, "Subclasses must implement the `find` method"
    end

    # Retrieves all records from the specified table.
    #
    # @param table [String] the name of the table
    # @raise [NotImplementedError] if the method is not implemented in a subclass
    # @return [Array<Hash>] an array of hashes representing records
    def all(table:)
      raise NotImplementedError, "Subclasses must implement the `all` method"
    end

    # Creates a new record in the specified table.
    #
    # @param table [String] the name of the table
    # @param attributes [Hash] the attributes for the new record
    # @raise [NotImplementedError] if the method is not implemented in a subclass
    # @return [String] the ID of the created record
    def create(table:, attributes:)
      raise NotImplementedError, "Subclasses must implement the `create` method"
    end

    # Updates a record by its ID in the specified table.
    #
    # @param table [String] the name of the table
    # @param id [String] the ID of the record
    # @param attributes [Hash] the updated attributes
    # @raise [NotImplementedError] if the method is not implemented in a subclass
    # @return [void]
    def update(table:, id:, attributes:)
      raise NotImplementedError, "Subclasses must implement the `update` method"
    end

    # Deletes a record by its ID in the specified table.
    #
    # @param table [String] the name of the table
    # @param id [String] the ID of the record
    # @raise [NotImplementedError] if the method is not implemented in a subclass
    # @return [void]
    def delete(table:, id:)
      raise NotImplementedError, "Subclasses must implement the `delete` method"
    end
  end
end

require_relative 'database_adapter/simple_db'