# frozen_string_literal: true

Dir.glob(File.join(__dir__, 'true_way/**/*.rb')).each do |file|
  require_relative file
end
