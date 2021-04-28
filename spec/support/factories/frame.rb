# frozen_string_literal: true

Factory.define(:frame) do |f|
  f.serial_number 1
  f.balls []
  f.state 'playing'

  f.timestamps
end
