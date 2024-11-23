# frozen_string_literal: true

module Lesson4
  module App
    # The `Model` module provides a base class and supporting functionality
    # for all models in the application. It abstracts the interaction with
    # the database adapter, offering a clean interface for CRUD operations.
    #
    # ## Features
    #
    # - Centralized management of database interactions.
    # - Support for table name generation based on class name.
    # - Handles database adapter configuration and error handling.
    #
    # @see Lesson4::App::Model::Base
    #
    # @example Defining a new model
    #   class Lesson4::App::Model::Station < Lesson4::App::Model::Base
    #   end
    #
    # @example Configuring the database adapter
    #   Lesson4::App::Model::Base.db_adapter = DatabaseAdapter::SimpleDB.new('./db/simple_db')
    #
    # @example Creating a new record
    #   station = Lesson4::App::Model::Station.create(name: 'Central', capacity: 50)
    #   puts station.id # Outputs the new record's ID
    #
    # @example Retrieving a record by ID
    #   station = Lesson4::App::Model::Station.find('some-id')
    #   if station
    #     puts station.attributes # Outputs the record's attributes
    #   end
    #
    # @example Retrieving all records
    #   stations = Lesson4::App::Model::Station.all
    #   stations.each do |station|
    #     puts station.attributes
    #   end
    #
    # @example Updating an existing record
    #   station = Lesson4::App::Model::Station.find('some-id')
    #   if station
    #     station.attributes['capacity'] = 100
    #     station.save
    #   end
    #
    # @example Deleting a record
    #   station = Lesson4::App::Model::Station.find('some-id')
    #   station.destroy if station
    module Model
      # Custom error for missing database adapter
      class MissingDatabaseAdapterError < StandardError
        def initialize(msg = 'Database adapter is not configured') = super
      end

      # Base class for all models.
      # Provides generic CRUD functionality and abstraction over the database adapter.
      class Base
        class << self
          # Sets the database adapter for all models.
          # @return [DatabaseAdapter::Base] the database adapter
          attr_accessor :db_adapter

          # Returns the name of the table associated with the model.
          # @return [String] the table name in snake_case
          def table_name = @table_name ||= "#{name&.split('::')&.last.gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase}s"

          # Finds a record by its ID and returns it as an instance of the model.
          #
          # If the record is not found, the method returns nil.
          #
          # @param id [String] the ID of the record
          # @raise [Lesson4::App::Model::MissingDatabaseAdapterError] if `db_adapter` is not configured
          # @return [Base, nil] the model instance or nil if not found
          def find(id)
            raise MissingDatabaseAdapterError if db_adapter.nil?

            wrap(db_adapter.find(table: table_name, id: id))
          end

          # Retrieves all records from the associated table as instances of the model.
          #
          # This method fetches all records from the table defined by the class
          # using the `db_adapter`. The records are returned as an array of
          # instances of the current model.
          #
          # @raise [Lesson4::App::Model::MissingDatabaseAdapterError] if `db_adapter` is not configured
          # @return [Array<Base>] an array of model instances
          def all
            raise MissingDatabaseAdapterError if db_adapter.nil?

            db_adapter.all(table: table_name).map { |record| new(**record) }
          end

          # Creates a new record in the associated table and returns the created model instance.
          #
          # @param attributes [Hash] the attributes for the new record
          # @raise [Lesson4::App::Model::MissingDatabaseAdapterError] if `db_adapter` is not configured
          # @return [Base] the newly created model instance
          def create(attributes)
            raise MissingDatabaseAdapterError if db_adapter.nil?

            id = db_adapter.create(table: table_name, attributes: attributes)
            new(**attributes.merge(id: id))
          end

          private

          # Wraps raw data into a model instance.
          # @param data [Hash, nil] the raw data from the database
          # @return [Base, nil] the model instance or nil
          def wrap(data) = data ? new(**data) : nil
        end

        # @return [String] the ID of the record
        attr_reader :id
        # @return [Hash] the attributes of the record
        attr_accessor :attributes

        # Initializes a model instance with attributes.
        # @param attributes [Hash] the attributes for the model
        def initialize(**attributes)
          @id = attributes.delete(:id)
          @attributes = attributes
        end

        # Saves the current model instance to the database.
        #
        # If the instance already has an ID, the record is updated. Otherwise,
        # a new record is created in the database.
        #
        # @return [Base] the saved model instance
        def save
          if id
            self.class.db_adapter.update(table: self.class.table_name, id: id, attributes: attributes)
          else
            @id = self.class.db_adapter.create(table: self.class.table_name, attributes: attributes)
          end
          self
        end

        # Deletes the current model instance from the database.
        # @return [void]
        def destroy
          self.class.db_adapter.delete(table: self.class.table_name, id: id) if id
        end
      end
    end
  end
end

require_relative 'model/route'
require_relative 'model/station'
require_relative 'model/train'