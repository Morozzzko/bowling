# frozen_string_literal: true

require 'bowling/repository'
require 'bowling/game'

module Bowling
  module Repositories
    class Games < Repository[:games]
      def [](uid)
        root.combine(:frames).where(uid: uid).map_to(Bowling::Game).one!
      end

      def create(game)
        root.transaction do
          root.changeset(:create, game).map(:add_timestamps).commit.tap do |persisted_game|
            replace_frames(game, persisted_game)
          end
        end
      end

      private

      def replace_frames(game, persisted_game)
        frames.where(game_id: persisted_game[:id]).delete

        frames.changeset(:create, game.frames).map(:add_timestamps).map do |tuple|
          tuple.merge(game_id: persisted_game[:id])
        end.commit
      end
    end
  end
end
