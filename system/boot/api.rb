# frozen_string_literal: true

Bowling::Container.boot :api do
  start do
    require 'bowling/api/application'

    register('api.application') { Bowling::API::Application.app }
  end
end
