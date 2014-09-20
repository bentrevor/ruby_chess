require 'spec_helper'

describe ChessRules do
  let(:white_rook)   { PieceFactory.create :white, :rook }
  let(:white_king)   { PieceFactory.create :white, :king }
  let(:black_king)   { PieceFactory.create :black, :king }
  let(:black_pawn)   { PieceFactory.create :black, :pawn }
  let(:white_pawn)   { PieceFactory.create :white, :pawn }
  let(:white_bishop) { PieceFactory.create :white, :bishop }

  let(:board) { ChessBoard.new({'d4' => white_rook}) }

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

  describe 'horizontal/vertical #moves_for' do
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

  describe 'diagonal #moves_for' do
    let(:board) { ChessBoard.new({'d4' => white_bishop}) }

    it 'knows what moves are legal for a diagonally-moving piece' do
      %w[a1 b2 c3 e5 f6 g7 h8 a7 b6 c5 e3 f2 g1].each do |space|
        expect(ChessRules.moves_for(board, 'd4')).to include space
      end
    end

    it "doesn't let a piece move through a teammate" do
      board.get_space('f6').piece = white_pawn
      expect(ChessRules.moves_for(board, 'd4')).to include 'e5'
      expect(ChessRules.moves_for(board, 'd4')).not_to include 'f6'

      board.get_space('b2').piece = white_pawn
      expect(ChessRules.moves_for(board, 'd4')).to include 'c3'
      expect(ChessRules.moves_for(board, 'd4')).not_to include 'b2'

      board.get_space('b6').piece = white_pawn
      expect(ChessRules.moves_for(board, 'd4')).to include 'c5'
      expect(ChessRules.moves_for(board, 'd4')).not_to include 'b6'

      board.get_space('f2').piece = white_pawn
      expect(ChessRules.moves_for(board, 'd4')).to include 'e3'
      expect(ChessRules.moves_for(board, 'd4')).not_to include 'f2'
      expect(ChessRules.moves_for(board, 'd4')).not_to include 'd4'
    end

    it "lets a piece capture another piece" do
      board.get_space('f6').piece = black_pawn
      expect(ChessRules.moves_for(board, 'd4')).to include 'e5'
      expect(ChessRules.moves_for(board, 'd4')).to include 'f6'
      expect(ChessRules.moves_for(board, 'd4')).not_to include 'g7'

      board.get_space('b2').piece = black_pawn
      expect(ChessRules.moves_for(board, 'd4')).to include 'c3'
      expect(ChessRules.moves_for(board, 'd4')).to include 'b2'
      expect(ChessRules.moves_for(board, 'd4')).not_to include 'a1'

      board.get_space('b6').piece = black_pawn
      expect(ChessRules.moves_for(board, 'd4')).to include 'c5'
      expect(ChessRules.moves_for(board, 'd4')).to include 'b6'
      expect(ChessRules.moves_for(board, 'd4')).not_to include 'a7'

      board.get_space('f2').piece = black_pawn
      expect(ChessRules.moves_for(board, 'd4')).to include 'e3'
      expect(ChessRules.moves_for(board, 'd4')).to include 'f2'
      expect(ChessRules.moves_for(board, 'd4')).not_to include 'g1'
      expect(ChessRules.moves_for(board, 'd4')).not_to include 'd4'
    end
  end

  describe '#in_check?' do
    it 'knows when the king is in check' do
      board.get_space('d8').piece = black_king
      board.get_space('h8').piece = white_king

      expect(ChessRules.in_check?(board, :white)).to be false
      expect(ChessRules.in_check?(board, :black)).to be true
    end
  end
end
