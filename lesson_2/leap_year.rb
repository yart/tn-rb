# frozen_string_literal: true

require 'date'
require_relative '../lib/cui'

def leap?(year)      = (year % 400).zero? || (year % 4).zero? && !(year % 100).zero?
def months(date)     = [31, leap?(date.last) ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
def day_number(date) = date.first + months(date).take(date[1] - 1).inject(0) { _1 + _2 }
def date_input       = CUI::Input::BulkNumber.new(separator: '-', limit: 3)

puts 'Определяем порядковый номер дня в году по дате.'
puts 'Введите дату либо одной строкой в формате: '
puts '"ДД-ММ-ГГГГ", например: "22-06-1941" (без'
puts 'кавычек), либо по одному числу в том же порядке:'
puts 'день, месяц, год.'

date = date_input.receive

puts "\nПорядковый номер даты #{Date.new(*date.reverse).to_s.split('-').reverse.join('-')} — #{day_number(date)}"
