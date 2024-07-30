# frozen_string_literal: true

require_relative 'lib/entertaining_math'

def dimensions
  dimensions = []

  loop do
    return dimensions if dimensions.size == 3

    user_input = CUI.input

    if user_input.instance_of?(Integer) || user_input.instance_of?(Float)
      dimensions << user_input
      next
    end

    splitted_user_input = user_input.gsub(/[^0-9,]/, '').squeeze(',').split(',').map(&:to_i).take(3)

    return splitted_user_input if splitted_user_input.count == 3

    dimensions += splitted_user_input
  end
end

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
given_dimensions = dimensions
type = EntertainingMath::Trig.triangle_type(*given_dimensions)

puts "\nСудя по размерам сторон — #{given_dimensions.join(', ')} — это #{answer[type]} треугольник."
