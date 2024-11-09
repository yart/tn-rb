# frozen_string_literal: true

require 'yaml'
require 'random/formatter'

# A simple file based DB realisation
class SimpleDB
  attr_reader :location

  def initialize(location = 'simple_db')
    @location = location
  end

  def tables
  end

  class Error < ::StandardError; end

  class EmptyTableNameError < Error; end

  # Precents a table directory
  class Table
    def initialize(**table)
      @db_dir = table[:dir]
      @name   = table[:name]
      @table  = fetch_table
    end

    def create(table = nil)
      raise SimpleDB::EmptyTableNameError if @table.nil?

      Dir.mkdir(dir_name(table))
    end

    # TODO: it must return the Row objects in Array
    def all
      @table.map { load(_1) }
    end

    # TODO: it must return the Row object
    def select(uuid)
      load(file_name(uuid)) if @table.select { _1 == "#{uuid}.yml" }
    end

    # TODO: it must be ready to receive as a Row object so a Hash
    def save(uuid, row) = File.open(file_name(uuid), 'w') { _1.write row.to_yaml }

    private

    # Returns UUID v7 and shall save even parts of milliseconds for better sorting by creation time
    def build_uuid            = Random.new.uuid_v7(extra_timestamp_bits: 12)
    def load(uuid)            = YAML.load_file(uuid)
    def file_name(name = nil) = name.nil? ? "#{@name}/#{build_uuid}.yml" : "#{@name}/#{name}.yml"
    def dir_name(name = nil)  = name.nil? ? "#{@db_dir}/#{@name}" : "#{@db_dir}/#{name}"

    def fetch_table
      return Dir.children(dir_name) if Dir.exist?(dir_name)

      nil
    end
  end

  # Precents a table row
  class Row
    # @param columns [Hash, YAML]
    def initialize(columns)
      @columns = columns

      fetch_hash
    end

    # TODO: create a method to_yaml based on Psych.safe_dump

    private

    def fetch_hash
      @columns = YAML.safe_load(@columns, symbolize_names: true, permitted_classes: [Date]) unless @columns.is_a?(Hash)
    end
  end
end
