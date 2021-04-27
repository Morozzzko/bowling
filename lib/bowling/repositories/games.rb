# frozen_string_literal: true

require 'bowling/repository'
require 'bowling/game'

module Bowling
  module Repositories
    class Games < Repository[:games]
      def [](uid)
        root.where(uid: uid).map_to(Bowling::Game).one!
      end

      def create(player_name:)
        root.changeset(
          :create,
          player_name: player_name,
          state: 'playing',
          uid: SecureRandom.hex
        ).map(:add_timestamps).commit.then(&Bowling::Game)
      end
    end
  end
end
