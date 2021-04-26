# frozen_string_literal: true

require 'roda'

module Bowling
  module API
    class Application < Roda
      plugin :json_parser
      plugin :request_headers
      plugin :heartbeat
    end
  end
end
