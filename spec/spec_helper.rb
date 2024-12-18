# frozen_string_literal: true

require_relative '../lib/cui'
require_relative '../lib/database_adapter'
require_relative '../lesson_3/lib/railroad'
require_relative '../lesson_4/lib/true_way'
require_relative '../lesson_4/lib/railroad'
require_relative '../lesson_4/app'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
