# frozen_string_literal: true

require 'bowling/frame'

module Bowling
  class NextFrameState
    def call(frame, pins)
      return :too_many_pins if pins > 10

      case frame
      # Any last throw is recorded as-is, even if it's a strike
      in Frame(balls: [], serial_number: 10)
        frame.new(balls: [pins])
      # Even if the first ball of the last frame was a strike, we'll accept anything
      in Frame(balls: [10], serial_number: 10)
        frame.new(balls: [10, pins])
      # A spare doesn't end the last frame
      in Frame(balls: [ball], serial_number: 10) if ball + pins == 10
        frame.new(balls: [ball, pins])
      # Anything which is not a first ball, a strike or a spare, ends the frame
      in Frame(balls: balls, serial_number: 10)
        frame.new(balls: [*balls, pins], state: 'ended')
      # Strike ends the frame
      in Frame(balls: []) if pins == 10
        frame.new(balls: [pins], state: 'ended')
      # Can't knock down more pins than possible
      in Frame(balls: [ball]) if pins + ball > 10
        :too_many_pins
      # Second ball ends the game
      in Frame(balls: [ball])
        frame.new(balls: [ball, pins], state: 'ended')
      # First ball which is not a strike is recorded as-is
      in Frame(balls: [])
        frame.new(balls: [pins])
      end
    end
  end
end
