# frozen_string_literal: true

module Bowling
  module Games
    class Create
      include Bowling::Injector['repositories.games']

      def call(player_name)
        games.create(player_name: player_name)
      end
    end
  end
end
