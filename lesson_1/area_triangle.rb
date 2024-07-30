# frozen_string_literal: true

require_relative 'lib/entertaining_math'

puts "Вычисляем площадь треугольника.\n"
height = CUI.input('Введите высоту треугольника')
basement = CUI.input('Введите длину основания треугольника')
puts "\nПлощадь треугольника равна: #{EntertainingMath::Trig.triangle_area(basement, height)}"
