# frozen_string_literal: true

module CUI
  # @param prompt [String] will be shown to user
  # @return [String, Integer] according ot user input
  def input(prompt = nil)
    prompt = "#{prompt} " unless prompt.nil?

    print "#{prompt}> "

    string = gets.chomp

    string == string.to_i.to_s ? string.to_i : string
  end
end
