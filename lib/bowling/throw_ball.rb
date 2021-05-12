# frozen_string_literal: true

require 'bowling/game'
require 'bowling/next_frame_state'
require 'dry-monads'

module Bowling
  class ThrowBall
    include Dry::Monads[:result]

    def call(game, knocked_down_pins)
      *previous_frames, _ = game.frames

      return Failure(:game_ended) if game.ended?

      case next_frame_state.call(game.current_frame, knocked_down_pins)
      # Once the last frame ends, we'll end the whole game
      in Frame(state: 'ended', serial_number: 10) => frame
        Success(
          game.new(frames: [*previous_frames, frame], state: 'ended')
        )
      # We add new frames after the previous ones have ended
      in Frame(state: 'ended') => frame
        Success(
          game.new(frames: [*previous_frames, frame, Frame.new(serial_number: next_frame_number(game))])
        )
      # Just update a frame after a throw
      in Frame => frame
        Success(
          game.new(frames: [*previous_frames, frame])
        )
      # Propagate errors
      in Symbol => error
        Failure(error)
      end
    end

    private

    def next_frame_number(game)
      game.frames.count + 1
    end

    def next_frame_state
      @next_frame_state ||= NextFrameState.new
    end
  end
end
