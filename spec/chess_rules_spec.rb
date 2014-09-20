require 'spec_helper'

describe ChessRules do
  let(:rook)  { PieceFactory.create :white, :rook }
  let(:board) { ChessBoard.new({'a1' => rook}) }

  describe '#valid_move?' do
    it 'knows when a move is valid' do
      move = 'a1 - a2'

      expect(ChessRules.valid_move?(move, board, :white)).to eq true
    end

    it 'is false when there is no piece in original space' do
      invalid_move = 'a4 - a5'

      expect(ChessRules.valid_move?(invalid_move, board, :white)).to eq false
    end

    it 'is false when it tries to move the wrong color piece' do
      move = 'a1 - a2'

      expect(ChessRules.valid_move?(move, board, :black)).to eq false
    end

    it 'is false when it tries to make an illegal move' do
      expect(ChessRules.valid_move?('a1 - a2', board, :white)).to eq true
      expect(ChessRules.valid_move?('a1 - a3', board, :white)).to eq true
      expect(ChessRules.valid_move?('a1 - b2', board, :white)).to eq false
    end
  end
end
