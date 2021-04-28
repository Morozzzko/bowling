# frozen_string_literal: true

require 'types'

module Persistence
  module Relations
    class Frames < ROM::Relation[:sql]
      schema(:frames) do
        attribute :id, Types::Integer
        attribute :game_id, Types::Integer.meta(foreign_key: true)
        attribute :serial_number, Types::Integer
        attribute :state, Types::String
        attribute :balls, ::Types::JSON::IntegerArray

        attribute :created_at, Types::Time
        attribute :updated_at, Types::Time
      end

      dataset do
        order(:serial_number)
      end
    end
  end
end
