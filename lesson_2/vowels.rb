# frozen_string_literal: true

pp %w[a e i o u].map { [_1, ('a'..'z').to_a.index(_1) + 1] }.to_h
pp %w[а е ё и о у ы э ю я].map { [_1, ('а'..'ё').to_a.index(_1) + 1] }.to_h
