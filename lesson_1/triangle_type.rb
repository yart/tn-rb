# frozen_string_literal: true

require_relative 'lib/entertaining_math'

answer = {
  EntertainingMath::Trig::Triangle::EQUILATERAL => 'равносторонний',
  EntertainingMath::Trig::Triangle::ISOSCELES => 'равнобедренный',
  EntertainingMath::Trig::Triangle::SQUARE => 'квадратный',
  EntertainingMath::Trig::Triangle::CASUAL => 'обычный'
}

puts "Определяем тип треугольника по размерам его сторон.\n"
puts 'Вы можете ввести длины сторон треугольника как по одной,'
puts 'так и все сразу, разделяя их запятой. Если будет введено'
puts 'больше трёх чисел, учитываться будут только первые три.'
puts 'Обратите внимание, что принимаются только целые числа.'

user_input = CUI::Input.new(list: true, type: CUI::Input::NUMBER, max_items: 3)
given_dimensions = user_input.receive

type = EntertainingMath::Trig.triangle_type(*given_dimensions)

puts "\nСудя по размерам сторон — #{given_dimensions.join(', ')} — это #{answer[type]} треугольник."
