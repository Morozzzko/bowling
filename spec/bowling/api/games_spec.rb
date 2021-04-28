# frozen_string_literal: true

require 'bowling/api/application'
require 'oj'

RSpec.describe Bowling::API::Application, type: :http do # rubocop:disable RSpec/FilePath
  subject(:app) { described_class }

  let(:json_body) do
    Oj.load(response.body)
  rescue StandardError
    nil
  end

  let(:games) { Bowling::Container['repositories.games'] }

  describe 'POST api/games' do
    subject(:response) { post '/api/games', json_params, { 'CONTENT_TYPE' => 'application/json' } }

    let(:json_params) { Oj.dump(params, mode: :compat) }

    context 'when params are missing' do
      let(:json_params) { nil }

      it 'responds with an error' do
        expect(response.status).to be(422)
        expect(json_body).to eql(
          {
            'status' => 'validation_error',
            'errors' => [{
              'param_name' => 'player_name',
              'error' => 'missing'
            }]
          }
        )
      end
    end

    context 'when params are provided' do
      let(:params) { { player_name: 'Vic' } }

      it 'creates a new game' do
        expect(response).to be_successful
        expect(json_body).to match({ 'game_uid' => String })

        game_uid = json_body['game_uid']

        game = games[game_uid]

        expect(game.player_name).to eql('Vic')
        expect(game.state).to eql('playing')
      end
    end
  end

  describe 'GET api/games/:uid' do
    subject(:response) { get "api/games/#{uid}" }

    let(:uid) { game.uid }

    let(:game) { Factory[:game] }

    it 'returns game info and score' do
      expect(response).to be_successful
      expect(json_body).to match(
        {
          'uid' => game.uid,
          'player_name' => game.player_name,
          'state' => game.state,
          'score' => Hash
        }
      )
    end
  end
end
