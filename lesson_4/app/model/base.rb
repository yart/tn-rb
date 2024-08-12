# frozen_string_literal: true

require 'random/formatter'

module Lesson4
  module App
    module Model
      # Presents common model's entity.
      class Base
        def initialize(entity, db = Lesson4::App::DB)
          @data  = entity[:data]
          @uuid  = entity[:uuid] || Random.uuid
          @table = db.new(name:)
        end

        class << self
          def all        = @table.all
          def find(uuid) = @table.select(uuid)
        end

        def save = @table.save(@uuid, @data)

        private

        def name = raise NoMethodError
      end
    end
  end
end
