# frozen_string_literal: true

require 'roda'

module Bowling
  module API
    class Application < Roda
      plugin :json_parser
      plugin :json
      plugin :request_headers
      plugin :heartbeat
      plugin :typecast_params
      plugin :error_handler

      error do |error|
        case error
        when ::Roda::RodaPlugins::TypecastParams::Error
          response.status = 422

          {
            status: 'validation_error',
            errors: [{
              param_name: error.param_name,
              error: error.reason
            }]
          }
        else
          raise error
        end
      end

      # rubocop:disable Metrics/BlockLength
      route do |routes|
        routes.on('api') do
          routes.on('games') do
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
              routes.is do
                routes.get do
                  games = Container['repositories.games']
                  game = games[uid]

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
      end
      # rubocop:enable Metrics/BlockLength
    end
  end
end
