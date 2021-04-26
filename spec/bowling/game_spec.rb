# frozen_string_literal: true

require 'bowling/game'

RSpec.describe Bowling::Game do
  subject(:new_game) { described_class.new }

  describe '#throw_ball' do
    subject(:throw_ball) { game.throw_ball(knocked_down_pins) }

    context 'when first in frame' do
      let(:game) { new_game }
      let(:knocked_down_pins) { 8 }

      it 'records a ball' do
        expect(throw_ball).to be_a(described_class)
        expect(throw_ball.current_frame.balls).to eql([knocked_down_pins])
        expect(throw_ball.frames.count).to be(1)
      end
    end

    context 'when strike' do
      let(:game) { new_game }
      let(:knocked_down_pins) { 10 }

      it 'records a strike an adds a frame' do
        expect(throw_ball).to be_a(described_class)
        expect(throw_ball.frames.first).to be_strike
        expect(throw_ball.frames.count).to be(2)
        expect(throw_ball.current_frame.balls).to eql([])
      end
    end

    context 'when 10, but not a strike' do
      let(:game) { new_game.throw_ball(3) }
      let(:knocked_down_pins) { 7 }

      it 'records a spare and adds a frame' do
        expect(throw_ball).to be_a(described_class)
        expect(throw_ball.frames.first).to be_spare
        expect(throw_ball.frames.count).to be(2)
        expect(throw_ball.current_frame.balls).to eql([])
      end
    end

    context 'when knocked down more pins than possible' do
      let(:game) { new_game.throw_ball(9) }
      let(:knocked_down_pins) { 7 }

      it 'raises an error' do
        expect(throw_ball).to be(:too_many_pins)
      end
    end

    describe 'finishing a game with all strikes' do
      specify do
        game = (1..12).reduce(new_game) do |game, _|
          game.throw_ball(10)
        end

        expect(game).to be_ended
        expect(game.frames.count).to be(10)
        expect(game.frames).to all(be_ended)
        expect(game.balls.count).to be(12)
      end
    end

    describe 'finishing a game with only a spare' do
      specify do
        game = (1..18).reduce(new_game) do |game, _|
          game.throw_ball(0)
        end.throw_ball(3).throw_ball(7)

        expect(game).not_to be_ended
        expect(game.frames.count).to be(10)
        expect(game.balls.count).to be(20)

        finished_game = game.throw_ball(0)

        expect(finished_game).to be_ended
      end
    end
  end
end
