require 'spec_helper'

describe Player do
  let(:board) { Board.new({}) }
  let(:rules) { Rules }

  specify 'human players use input to decide a move' do
    input = double 'input'
    player = Player.new input, :white

    expect(input).to receive :get_move

    player.get_move(rules)
  end

  specify 'computer players use ai to decide a move' do
    ai = instance_double 'AI'
    player = Player.new ai, :white

    expect(ai).to receive(:get_move)

    player.get_move(rules)
  end
end
