# frozen_string_literal: true

require_relative 'lib/entertaining_math'

def identify_sign(number) = number.negative? ? '-' : '+'

def perform_equation(coeffs)
  a, b, c = coeffs

  first_sign = identify_sign(b)
  second_sign = identify_sign(c)

  "#{a}x² #{first_sign} #{b.abs}x #{second_sign} #{c.abs} = 0"
end

puts 'Вычисляем корни квадратного уравнения вида ax² + bx + c = 0.'
puts 'Достаточно ввести коэффициенты a, b и с, перечислив их через'
puts 'запятую, или добавляя по одному.'
puts 'Обратите, пожалуйста, внимание, что на ввод принимаются только'
puts 'целые числаж!'

user_input   = CUI::Input.new(list: true, type: CUI::Input::NUMBER, max_items: 3, allow_negatives: true)
coefficients = user_input.receive
equation     = perform_equation(coefficients)

roots = EntertainingMath::Algebra.square_roots(*coefficients)

answer =
  if roots == :no_roots
    "Заданное квадратное уравнение #{equation} не имеет корней."
  elsif roots.count == 1
    "Заданное квадратное уравнение #{equation} имеет только один корень: #{roots}."
  else
    "#{roots} — корни заданного квадратного уравнения #{equation}."
  end

puts "\n#{answer}"
