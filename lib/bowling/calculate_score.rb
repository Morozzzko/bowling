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
      if strike?(frame)
        balls = next_frames.flat_map(&:balls).take(2)

        10 + balls.sum
      elsif spare?(frame)
        balls = next_frames.flat_map(&:balls).take(1)

        10 + balls.sum
      else
        frame.balls.sum
      end
    end

    def strike?(frame)
      case frame
      in Frame(balls: [10])
        true
      in LastFrame(balls: [10])
        true
      else
        false
      end
    end

    def spare?(frame)
      case frame
      in Frame(balls: [first, second]) if first + second == 10
        true
      in LastFrame(balls: [first, second]) if first + second == 10
        true
      else
        false
      end
    end
  end
end
