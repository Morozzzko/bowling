# frozen_string_literal: true

require 'bowling/throw_ball'

# rubocop:disable Metrics/BlockLength
module Bowling
  module API
    class Application < Roda
      route do |routes|
        serialize_game = Container['api.serializers.game']

        routes.on('api/games') do
          routes.is do
            routes.post do
              player_name = typecast_params.nonempty_str!('player_name')

              game = Container['games.create'].call(player_name)

              {
                game_uid: game.uid
              }
            end
          end

          routes.on String do |uid|
            games = Container['repositories.games']
            game = games[uid]

            routes.is do
              routes.get do
                serialize_game.call(game)
              end
            end

            routes.on 'knocked_down_pins' do
              routes.post do
                knocked_down_pins = typecast_params.Integer!('pins')
                case Bowling::ThrowBall.new.call(game, knocked_down_pins)
                in Failure(error)
                  response.status = 422
                  {
                    status: 'bowling_error',
                    error_code: error.to_s
                  }
                in Success(new_game_state)
                  games.update(new_game_state)
                  serialize_game.call(new_game_state)
                end
              end
            end
          end
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
