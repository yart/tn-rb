# frozen_string_literal: true

require 'yaml'

require_relative '../lib/cui'
require_relative 'lib/railroad'
require_relative 'app/model'
require_relative 'app/view'
require_relative 'app/controller'

# Presents the Railroad app.
module App
  self.l10n = YAML.load_file('config/l10n.yml', symbolize_names: true)
end
