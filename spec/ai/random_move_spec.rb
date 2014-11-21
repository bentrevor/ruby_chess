require 'spec_helper'

describe RandomMove do
  let(:board)   { Board.new({:a1 => white_rook}) }
  let(:player1) { Player.new(double, :white) }
  let(:player2) { Player.new(double, :black) }
  let(:rules)   { Rules.new(board, player1, player2) }

  it 'picks a random move' do
    expect(RandomMove.get_move(rules)).to be_a Move
  end
end
