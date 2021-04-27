# frozen_string_literal: true

require 'bowling/game'

module Bowling
  module Games
    class Create
      def call(player_name)
        Game.new(player_name: player_name)
      end
    end
  end
end
