# frozen_string_literal: true

def fibonacci(num) = (0..1).include?(num) ? num : fibonacci(num - 2) + fibonacci(num - 1)

pp (0..11).map { fibonacci(_1) }
