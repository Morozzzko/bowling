# frozen_string_literal: true

require 'bowling/game'

RSpec.describe Bowling::Game do
  subject(:new_game) { described_class.new(player_name: 'Vic') }

  describe '#throw_ball' do
    subject(:throw_ball) { game.throw_ball(knocked_down_pins) }

    let(:resulting_game) { throw_ball.value! } # TODO: FIXME

    context 'when first in frame' do
      let(:game) { new_game }
      let(:knocked_down_pins) { 8 }

      it 'records a ball' do
        expect(throw_ball).to match(Success(described_class))
        expect(resulting_game.current_frame.balls).to eql([knocked_down_pins])
        expect(resulting_game.frames.count).to be(1)
      end
    end

    context 'when strike' do
      let(:game) { new_game }
      let(:knocked_down_pins) { 10 }

      it 'records a strike an adds a frame' do
        expect(throw_ball).to match(Success(described_class))
        expect(resulting_game.frames.first).to be_strike
        expect(resulting_game.frames.count).to be(2)
        expect(resulting_game.current_frame.balls).to eql([])
      end
    end

    context 'when 10, but not a strike' do
      let(:game) { new_game.throw_ball(3).value! }
      let(:knocked_down_pins) { 7 }

      it 'records a spare and adds a frame' do
        expect(throw_ball).to match(Success(described_class))
        expect(resulting_game.frames.first).to be_spare
        expect(resulting_game.frames.count).to be(2)
        expect(resulting_game.current_frame.balls).to eql([])
      end
    end

    context 'when knocked down more pins than possible' do
      let(:game) { new_game.throw_ball(9).value! }
      let(:knocked_down_pins) { 7 }

      it 'raises an error' do
        expect(throw_ball).to eql(Failure(:too_many_pins))
      end
    end

    describe 'finishing a game with all strikes' do
      specify do
        game = (1..12).reduce(Dry::Monads.Success(new_game)) do |game, _|
          game.bind { Bowling::ThrowBall.new.call(_1, 10) }
        end

        expect(game).to be_success

        game = game.value!
        expect(game).to be_ended
        expect(game.frames.count).to be(10)
        expect(game.frames).to all(be_ended)
        expect(game.balls.count).to be(12)
      end
    end

    describe 'trying to throw more balls than possible' do
      specify do
        game = (1..20).reduce(Dry::Monads.Success(new_game)) do |game, _|
          game.bind { Bowling::ThrowBall.new.call(_1, 3) }
        end

        game = game.value!

        expect(game).to be_ended

        expect(Bowling::ThrowBall.new.call(game, 3)).to eql(Failure(:game_ended))

        # expect(game.frames.count).to be(10)
        # expect(game.frames).to all(be_ended)
        # expect(game.balls.count).to be(12)
      end
    end

    describe 'finishing a game with only a spare' do
      specify do
        game = (1..18).reduce(Success(new_game)) do |game, _|
          game.bind { _1.throw_ball(0) }
        end.bind { _1.throw_ball(3) }.bind { _1.throw_ball(7) }.value!

        expect(game).not_to be_ended
        expect(game.frames.count).to be(10)
        expect(game.balls.count).to be(20)

        finished_game = game.throw_ball(0).value!

        expect(finished_game).to be_ended
      end
    end
  end
end
