# frozen_string_literal: true

require 'bowling/api/application'
require 'oj'

RSpec.describe Bowling::API::Application, type: :http do # rubocop:disable RSpec/FilePath
  subject(:app) { described_class }

  describe 'POST api/games' do
    subject(:response) { post '/api/games', json_params, { 'CONTENT_TYPE' => 'application/json' } }

    let(:json_params) { Oj.dump(params, mode: :compat) }
    let(:json_body) do
      Oj.load(response.body)
    rescue StandardError
      nil
    end

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
      end
    end
  end
end
