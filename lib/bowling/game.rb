# frozen_string_literal: true

require 'dry-struct'
require 'securerandom'

require 'bowling/frame'
require 'bowling/next_frame_state'

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
