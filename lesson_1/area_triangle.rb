# frozen_string_literal: true

require_relative 'lib/entertaining_math'

puts "Вычисляем площадь треугольника.\n"
height   = CUI::Input.new(text: 'Введите высоту треугольника', type: CUI::Input::NUMBER).receive
basement = CUI::Input.new(text: 'Введите длину основания треугольника', type: CUI::Input::NUMBER).receive
puts "\nПлощадь треугольника с высотой #{height} и основанием #{basement}, равна: #{EntertainingMath::Trig.triangle_area(basement, height)}"
