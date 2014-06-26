require 'spec_helper'

describe ChessRules do
  let(:rook)  { PieceFactory.create :white, :rook }
  let(:board) { ChessBoard.new({'a1' => rook}) }

  describe '#valid_move?' do
    it 'knows when a move is valid' do
      move = 'a1 - a2'

      ChessRules.valid_move?(move, board, :white).should == true
    end

    it 'is false when there is no piece in original space' do
      invalid_move = 'a4 - a5'

      ChessRules.valid_move?(invalid_move, board, :white).should == false
    end

    it 'is false when it tries to move the wrong color piece' do
      move = 'a1 - a2'

      ChessRules.valid_move?(move, board, :black).should == false
    end

    it 'is false when it tries to make an illegal move' do
      ChessRules.valid_move?('a1 - a2', board, :white).should == true
      ChessRules.valid_move?('a1 - a3', board, :white).should == true
      ChessRules.valid_move?('a1 - b2', board, :white).should == false
    end
  end
end
