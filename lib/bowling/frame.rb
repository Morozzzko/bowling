# frozen_string_literal: true

require 'dry-struct'

module Bowling
  class Frame < Dry::Struct
    attribute :balls, Types.Array(Types::Integer).default([].freeze)
    attribute :state, Types::String.default('playing').enum('playing', 'ended')
    attribute :serial_number, Types::Integer.constrained(included_in: 1..10)

    def strike?
      balls == [10]
    end

    def spare?
      !strike? && balls.take(2).sum == 10
    end

    def ended?
      state == 'ended'
    end
  end
end
