# frozen_string_literal: true

require 'yaml'

require_relative '../lib/cui'
require_relative '../lib/simple_db'
require_relative 'lib/railroad'
require_relative 'app/model'
require_relative 'app/view'
require_relative 'app/controller'

module Lesson4
  # Presents the Railroad app.
  # Main application module, contains all starting settings
  module App
    def self.l10n = YAML.load_file("#{__dir__}/config/l10n.yml", symbolize_names: true)
    def self.dir  = __dir__
    def self.db   = SimpleDB::DB.new("#{dir}/db/simple_db")
  end
end
