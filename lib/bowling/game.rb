# frozen_string_literal: true

require 'dry-struct'
require 'securerandom'

require 'bowling/frame'
require 'bowling/next_frame_state'
require 'bowling/calculate_score'
require 'bowling/throw_ball'

module Bowling
  class Game < Dry::Struct
    attribute :frames, Types.Array(Frame).default([Frame.new(serial_number: 1)].freeze)
    attribute :state, Types::String.default('playing').enum('playing', 'ended')
    attribute :player_name, Types::String
    attribute :uid, (Types::UID.default { SecureRandom.hex })

    def current_frame
      frames.last
    end

    def ended?
      state == 'ended'
    end

    def balls
      frames.flat_map(&:balls)
    end

    def next_frame_number
      frames.count + 1
    end

    def score
      @score ||= calculate_score.call(self)
    end

    def throw_ball(knocked_down_pins)
      ThrowBall.new.call(self, knocked_down_pins)
    end

    private

    def calculate_score
      @calculate_score ||= CalculateScore.new
    end
  end
end
