require 'spec_helper'

describe ChessRules do
  let(:rook)       { PieceFactory.create :white, :rook }
  let(:king)       { PieceFactory.create :black, :king }
  let(:black_pawn) { PieceFactory.create :black, :pawn }
  let(:white_pawn) { PieceFactory.create :white, :pawn }
  let(:board) { ChessBoard.new({'d4' => rook}) }

  describe '#valid_move?' do
    it 'knows when a move is valid' do
      move = 'd4 - d5'

      expect(ChessRules.valid_move?(move, board, :white)).to eq true
    end

    it 'is false when there is no piece in original space' do
      invalid_move = 'a4 - a5'

      expect(ChessRules.valid_move?(invalid_move, board, :white)).to eq false
    end

    it 'is false when it tries to move the wrong color piece' do
      move = 'd4 - d5'

      expect(ChessRules.valid_move?(move, board, :black)).to eq false
    end

    it 'is false when it tries to make an illegal move' do
      expect(ChessRules.valid_move?('d4 - d8', board, :white)).to eq true
      expect(ChessRules.valid_move?('d4 - h4', board, :white)).to eq true
      expect(ChessRules.valid_move?('d4 - e5', board, :white)).to eq false
    end
  end

  describe '#moves_for' do
    it 'knows what moves are legal for a piece' do
      [1,2,3,5,6,7,8].each do |n|
        expect(ChessRules.moves_for(board, 'd4')).to include "d#{n}"
      end

      %w[a b c e f g h].each do |l|
        expect(ChessRules.moves_for(board, 'd4')).to include "#{l}4"
      end
    end

    it "doesn't let a piece move through a teammate" do
      board.get_space('d6').piece = white_pawn
      expect(ChessRules.moves_for(board, 'd4')).to include 'd5'
      expect(ChessRules.moves_for(board, 'd4')).not_to include 'd6'

      board.get_space('d2').piece = white_pawn
      expect(ChessRules.moves_for(board, 'd4')).to include 'd3'
      expect(ChessRules.moves_for(board, 'd4')).not_to include 'd2'

      board.get_space('b4').piece = white_pawn
      expect(ChessRules.moves_for(board, 'd4')).to include 'c4'
      expect(ChessRules.moves_for(board, 'd4')).not_to include 'b4'

      board.get_space('f4').piece = white_pawn
      expect(ChessRules.moves_for(board, 'd4')).to include 'e4'
      expect(ChessRules.moves_for(board, 'd4')).not_to include 'f4'
    end

    it "lets a piece capture another piece" do
      board.get_space('d6').piece = black_pawn
      expect(ChessRules.moves_for(board, 'd4')).to include 'd5'
      expect(ChessRules.moves_for(board, 'd4')).to include 'd6'
      expect(ChessRules.moves_for(board, 'd4')).not_to include 'd7'

      board.get_space('d2').piece = black_pawn
      expect(ChessRules.moves_for(board, 'd4')).to include 'd3'
      expect(ChessRules.moves_for(board, 'd4')).to include 'd2'
      expect(ChessRules.moves_for(board, 'd4')).not_to include 'd1'

      board.get_space('b4').piece = black_pawn
      expect(ChessRules.moves_for(board, 'd4')).to include 'c4'
      expect(ChessRules.moves_for(board, 'd4')).to include 'b4'
      expect(ChessRules.moves_for(board, 'd4')).not_to include 'a4'

      board.get_space('f4').piece = black_pawn
      expect(ChessRules.moves_for(board, 'd4')).to include 'e4'
      expect(ChessRules.moves_for(board, 'd4')).to include 'f4'
      expect(ChessRules.moves_for(board, 'd4')).not_to include 'g4'
    end
  end

  describe '#in_check?' do
    xit 'knows when the king is in check' do
      board.get_space('a8').piece = king

      expect(ChessRules.in_check?(board, :black)).to be true
    end
  end
end
