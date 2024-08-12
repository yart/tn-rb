# frozen_string_literal: true

require_relative 'yaml'

module Lesson4
  module App
    class DB
      def initialize(**table)
        @name = table[:name]
        @rows = table[:rows]

        @table = fetch_table
      end

      def all
        @table.map { load(_1) }
      end

      def select(uuid)
        load(file_name(uuid)) if @table.select { _1 == "#{uuid}.yml" }
      end

      def save(uuid, row) = File.open(file_name(uuid), 'w') { _1.write row.to_yaml }

      private

      def file_name(name) = "#{@name}/#{name}.yml"
      def load(uuid)      = YAML.load_file(uuid)

      def fetch_table
        return Dir.children(@name.to_s) if Dir.exist?(@name.to_s)

        Dir.mkdir(@name.to_s)
        []
      end
    end
  end
end
