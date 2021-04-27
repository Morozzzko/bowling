# frozen_string_literal: true

require 'dry-struct'
require 'securerandom'

module Types
  include Dry.Types

  UID = Types::String.constrained(min_size: 5)
end

module Bowling
  class NextFrameState
    def call(frame, pins)
      case frame
      in Frame(balls: []) if pins == 10
        frame.new(balls: [pins], state: 'ended')
      in Frame(balls: [ball]) if pins + ball > 10
        :too_many_pins
      in Frame(balls: [ball])
        frame.new(balls: [ball, pins], state: 'ended')
      in Frame(balls: [])
        frame.new(balls: [pins])
      in LastFrame(balls: [])
        frame.new(balls: [pins])
      in LastFrame(balls: [10])
        frame.new(balls: [10, pins])
      in LastFrame(balls: [ball]) if ball + pins == 10
        frame.new(balls: [ball, pins])
      in LastFrame(balls: balls)
        frame.new(balls: [*balls, pins], state: 'ended')
      end
    end
  end

  class Frame < Dry::Struct
    attribute :balls, Types.Array(Types::Integer).default([])
    attribute :state, Types::String.default('playing').enum('playing', 'ended')
    attribute :type, Types.Value('regular').default('regular')

    def strike?
      balls.first == 10
    end

    def spare?
      !strike? && balls.sum == 10
    end

    def ended?
      state == 'ended'
    end
  end

  class LastFrame < Dry::Struct
    attribute :balls, Types.Array(Types::Integer).default([])
    attribute :state, Types::String.default('playing').enum('playing', 'ended')
    attribute :type, Types.Value('last').default('last')

    def ended?
      state == 'ended'
    end
  end

  class Game < Dry::Struct
    attribute :frames, Types.Array(Frame | LastFrame).default([Frame.new])
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

    def throw_ball(knocked_down_pins)
      *previous_frames, _ = frames

      case next_frame_state.call(current_frame, knocked_down_pins)
      in Frame(state: 'ended') => frame if frames.count == 9
        new(frames: [*previous_frames, frame, LastFrame.new])
      in Frame(state: 'ended') => frame
        new(frames: [*previous_frames, frame, Frame.new])
      in Frame => frame
        new(frames: [*previous_frames, frame])
      in LastFrame(state: 'ended') => frame
        new(frames: [*previous_frames, frame], state: 'ended')
      in LastFrame => frame
        new(frames: [*previous_frames, frame])
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
