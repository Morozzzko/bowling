# frozen_string_literal: true

require 'bowling/game'
require 'bowling/calculate_score'

RSpec.describe Bowling::CalculateScore do
  subject(:score) { described_class.new.call(game) }

  describe '#call' do
    let(:new_game) { Bowling::Game.new(player_name: 'vic') }

    describe 'with first ball' do
      let(:game) { new_game.throw_ball(3).value! }

      it 'returns score equivalent to the number of pins' do
        expect(score).to eql(
          {
            1 => { balls: [3], score: 3 },
            :total => 3
          }
        )
      end
    end

    describe 'with a spare' do
      let(:game) { new_game.throw_ball(3).bind { _1.throw_ball(7) }.bind {_1.throw_ball(2) }.value! }

      it 'returns score equivalent ' do
        expect(score).to eql(
          {
            1 => { balls: [3, 7], score: 12 },
            2 => { balls: [2], score: 14 },
            :total => 14
          }
        )
      end
    end

    describe 'with first strike and two more successful balls' do
      let(:game) { new_game.throw_ball(10).bind { _1.throw_ball(5) }.bind {_1.throw_ball(0) }.value! }

      it 'returns score equivalent to the number of pins' do
        expect(score).to eql(
          {
            1 => { balls: [10], score: 15 },
            2 => { balls: [5, 0], score: 20 },
            3 => { balls: [], score: 20 },
            total: 20
          }
        )
      end
    end

    describe 'finishing a game with all strikes' do
      let(:game) do
        (1..12).reduce(Success(new_game)) do |game, _|
          game.bind { _1.throw_ball(10) }
        end.value!
      end

      it 'returns score of 300' do # rubocop:disable RSpec/ExampleLength
        expect(score).to eql(
          {
            1 => { balls: [10], score: 30 },
            2 => { balls: [10], score: 60 },
            3 => { balls: [10], score: 90 },
            4 => { balls: [10], score: 120 },
            5 => { balls: [10], score: 150 },
            6 => { balls: [10], score: 180 },
            7 => { balls: [10], score: 210 },
            8 => { balls: [10], score: 240 },
            9 => { balls: [10], score: 270 },
            10 => { balls: [10, 10, 10], score: 300 },
            :total => 300
          }
        )
      end
    end
  end
end
