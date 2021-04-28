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
            score: game.score
          }
        end
      end
    end
  end
end
