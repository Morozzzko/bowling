# frozen_string_literal: true

require 'bowling/game'

module Bowling
  module Games
    class Create
      include Bowling::Injector['repositories.games']

      def call(player_name)
        game = Bowling::Game.new(player_name: player_name)

        persisted_game = games.create(game)

        games[persisted_game.uid]
      end
    end
  end
end
