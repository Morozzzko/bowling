# frozen_string_literal: true

require 'bowling/api/application'
require 'oj'

RSpec.describe Bowling::API::Application, '/api/games/:uid/knocked_down_pins', type: :http do # rubocop:disable RSpec/FilePath, RSpec/DescribeMethod
  subject(:app) { described_class }

  let(:json_body) do
    Oj.load(response.body)
  rescue StandardError
    nil
  end

  let(:games) { Bowling::Container['repositories.games'] }

  describe 'POST api/games/:uid/knocked_down_pins' do
    subject(:response) do
      post "api/games/#{game[:uid]}/knocked_down_pins", json_params, { 'CONTENT_TYPE' => 'application/json' }
    end

    let(:json_params) { Oj.dump(params, mode: :compat) }
    let(:game) { Factory[:game] }

    context 'when params are missing' do
      let(:json_params) { nil }

      it 'responds with an error' do
        expect(response.status).to be(422)
        expect(json_body).to eql(
          {
            'status' => 'validation_error',
            'errors' => [{
              'param_name' => 'pins',
              'error' => 'missing'
            }]
          }
        )
      end
    end

    context 'with valid params' do
      let(:params) { { pins: 10 } }

      it 'registers that this frame has a strike' do
        expect(response.status).to be(200)
        expect(json_body).to match(
          'uid' => game.uid,
          'player_name' => game.player_name,
          'state' => game.state,
          'score' => Hash
        )

        game = games[json_body['uid']]

        expect(game.frames.count).to be(2)
        expect(game.frames.first.balls).to eql([10])
      end
    end

    context 'with invalid params' do
      let(:params) { { pins: 11 } }

      it 'responds with an error' do
        expect(response.status).to be(422)
        expect(json_body).to eql(
          {
            'status' => 'bowling_error',
            'error_code' => 'too_many_pins'
          }
        )
      end
    end
  end
end
