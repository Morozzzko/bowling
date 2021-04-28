# frozen_string_literal: true

module Bowling
  class CalculateScore
    def call(game)
      frames = game.frames

      recursive_score(frames, { total: 0 })
    end

    private

    def recursive_score(frames, score)
      previous_total = score[:total]

      case frames
      in [current, *next_frames]
        frame_score = frame_score(current, next_frames)

        recursive_score(
          next_frames,
          score.merge(
            current.serial_number => {
              balls: current.balls,
              score: previous_total + frame_score
            },
            total: previous_total + frame_score
          )
        )
      in []
        score
      end
    end

    def frame_score(frame, next_frames)
      if frame.strike?
        balls = next_frames.flat_map(&:balls).take(2)

        10 + balls.sum
      elsif frame.spare?
        balls = next_frames.flat_map(&:balls).take(1)

        10 + balls.sum
      else
        frame.balls.sum
      end
    end
  end
end
