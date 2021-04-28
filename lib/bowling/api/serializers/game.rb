# frozen_string_literal: true

module Bowling
  module API
    module Serializers
      class Game
        def call(game)
          {
            player_name: game.player_name,
            uid: game.uid,
            state: game.state,
            score: {
              1 => [],
              2 => [],
              3 => [],
              4 => [],
              5 => [],
              6 => [],
              7 => [],
              8 => [],
              9 => [],
              10 => [],
              total: 0
            }
          }
        end
      end
    end
  end
end
