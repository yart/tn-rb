# frozen_string_literal: true

{
  january: 31,
  february: 28,
  march: 31,
  aprile: 30,
  may: 31,
  june: 30,
  jule: 31,
  august: 31,
  september: 30,
  october: 31,
  november: 30,
  december: 31
}.select { puts _1 if _2 == 30 }
