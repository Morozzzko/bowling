# frozen_string_literal: true

require 'dry-struct'
require 'securerandom'

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

  class Frame < Dry::Struct
    attribute :balls, Types.Array(Types::Integer).default([].freeze)
    attribute :state, Types::String.default('playing').enum('playing', 'ended')
    attribute :serial_number, Types::Integer.constrained(included_in: 1..10)

    def strike?
      balls.first == 10
    end

    def spare?
      !strike? && balls.take(2).sum == 10
    end

    def ended?
      state == 'ended'
    end
  end

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

    def throw_ball(knocked_down_pins)
      *previous_frames, _ = frames

      case next_frame_state.call(current_frame, knocked_down_pins)
      # Once the last frame ends, we'll end the whole game
      in Frame(state: 'ended', serial_number: 10) => frame
        new(frames: [*previous_frames, frame], state: 'ended')
      # We add new frames after the previous ones have ended
      in Frame(state: 'ended') => frame
        new(frames: [*previous_frames, frame, Frame.new(serial_number: next_frame_number)])
      # Just update a frame after a throw
      in Frame => frame
        new(frames: [*previous_frames, frame])
      # Propagate errors
      in Symbol => error
        error
      end
    end

    private

    def next_frame_state
      @next_frame_state ||= NextFrameState.new
    end
  end
end
