require 'spec_helper'

describe Strategy do
  let(:strategy) { described_class }
  let(:board) { Board.new({}) }
  let(:rules) { Rules }
  let(:player) { Player.new(double('ai'), :black) }

  {
    :pawn   => 1,
    :knight => 3,
    :bishop => 3,
    :rook   => 5,
    :queen  => 9
  }.each do |piece, points|
    it "knows a #{piece} is worth #{points} points" do
      board.place_piece(Piece.create(:black, piece), 'd4')

      expect(strategy.score_board(board, rules, player)).to eq points
    end
  end
end
