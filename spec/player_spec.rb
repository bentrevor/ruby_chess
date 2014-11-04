require 'spec_helper'

describe Player do
  let(:board) { double 'board' }
  let(:rules) { double 'rules' }

  specify 'human players use input to decide a move' do
    input = double 'input'
    player = Player.new input

    expect(input).to receive :get_move

    player.get_move(board, rules)
  end

  specify 'computer players use ai to decide a move' do
    ai = class_double 'AI'
    player = Player.new ai

    expect(ai).to receive(:get_move).with(board, rules)

    player.get_move(board, rules)
  end
end
