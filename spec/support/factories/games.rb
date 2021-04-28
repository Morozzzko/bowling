# frozen_string_literal: true

Factory.define(:game) do |f|
  f.uid { SecureRandom.hex }
  f.player_name { 'Vic' }
  f.state { 'playing' }

  f.timestamps

  f.association(:frames, count: 1)
end
