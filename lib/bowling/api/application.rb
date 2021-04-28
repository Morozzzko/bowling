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
    end
  end
end

require 'bowling/api/routes'
