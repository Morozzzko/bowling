# frozen_string_literal: true

require 'bowling/api/application'

RSpec.describe Bowling::API::Application, type: :http do
  subject(:app) { described_class }

  it 'responds to a heartbeat' do
    get '/heartbeat'

    expect(last_response).to be_successful
  end
end
