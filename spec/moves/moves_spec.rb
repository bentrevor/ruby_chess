require 'spec_helper'

describe Moves do
  let(:board)   { Board.new({}) }
  let(:player1) { Player.new(double, :white) }
  let(:player2) { Player.new(double, :black) }
  let(:rules)   { Rules.new(board, player1, player2) }

  it 'returns an empty list if there is no piece in the starting space' do
    expect(Moves.for('a1', rules)).to eq []
  end

  it 'returns the moves for a piece' do
    board.place_piece(Piece.create(:white, :king), 'a1')

    expect(Moves.for('a1', rules).map(&:text).sort).to eq ['a1 - a2', 'a1 - b1', 'a1 - b2']
  end
end
