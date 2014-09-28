require 'spec_helper'

describe FindMoves do
  let(:black_king)   { Piece.create :black, :king }
  let(:black_knight) { Piece.create :black, :knight }
  let(:black_pawn)   { Piece.create :black, :pawn }
  let(:white_bishop) { Piece.create :white, :bishop }
  let(:white_king)   { Piece.create :white, :king }
  let(:white_pawn)   { Piece.create :white, :pawn }
  let(:white_rook)   { Piece.create :white, :rook }

  let(:board) { ChessBoard.new({'d4' => white_rook}) }

  describe 'horizontal/vertical moves' do
    it 'knows what moves are legal for a piece' do
      [1,2,3,5,6,7,8].each do |n|
        expect(FindMoves.call(board, 'd4')).to include "d#{n}"
      end

      %w[a b c e f g h].each do |l|
        expect(FindMoves.call(board, 'd4')).to include "#{l}4"
      end
    end

    it 'limits the length of moves' do
      board.place_piece(black_king, 'd4')

      %w[c5 d5 e5 e4 e3 d3 c3 c4].each do |space|
        expect(FindMoves.call(board, 'd4')).to include space
      end

      %w[b6 d6 f6 f4 f2 d2 b2 b4].each do |space|
        expect(FindMoves.call(board, 'd4')).not_to include space
      end
    end

    it "doesn't let a piece move through a teammate" do
      board.place_piece(white_pawn, 'd6')
      expect(FindMoves.call(board, 'd4')).to include 'd5'
      expect(FindMoves.call(board, 'd4')).not_to include 'd6'

      board.place_piece(white_pawn, 'd2')
      expect(FindMoves.call(board, 'd4')).to include 'd3'
      expect(FindMoves.call(board, 'd4')).not_to include 'd2'

      board.place_piece(white_pawn, 'b4')
      expect(FindMoves.call(board, 'd4')).to include 'c4'
      expect(FindMoves.call(board, 'd4')).not_to include 'b4'

      board.place_piece(white_pawn, 'f4')
      expect(FindMoves.call(board, 'd4')).to include 'e4'
      expect(FindMoves.call(board, 'd4')).not_to include 'f4'
    end

    it "lets a piece capture another piece" do
      board.place_piece(black_pawn, 'd6')
      expect(FindMoves.call(board, 'd4')).to include 'd5'
      expect(FindMoves.call(board, 'd4')).to include 'd6'
      expect(FindMoves.call(board, 'd4')).not_to include 'd7'

      board.place_piece(black_pawn, 'd2')
      expect(FindMoves.call(board, 'd4')).to include 'd3'
      expect(FindMoves.call(board, 'd4')).to include 'd2'
      expect(FindMoves.call(board, 'd4')).not_to include 'd1'

      board.place_piece(black_pawn, 'b4')
      expect(FindMoves.call(board, 'd4')).to include 'c4'
      expect(FindMoves.call(board, 'd4')).to include 'b4'
      expect(FindMoves.call(board, 'd4')).not_to include 'a4'

      board.place_piece(black_pawn, 'f4')
      expect(FindMoves.call(board, 'd4')).to include 'e4'
      expect(FindMoves.call(board, 'd4')).to include 'f4'
      expect(FindMoves.call(board, 'd4')).not_to include 'g4'
    end
  end

  describe 'diagonal #moves_for' do
    let(:board) { ChessBoard.new({'d4' => white_bishop}) }

    it 'knows what moves are legal for a diagonally-moving piece' do
      %w[a1 b2 c3 e5 f6 g7 h8 a7 b6 c5 e3 f2 g1].each do |space|
        expect(FindMoves.call(board, 'd4')).to include space
      end
    end

    it "doesn't let a piece move through a teammate" do
      board.place_piece(white_pawn, 'f6')
      expect(FindMoves.call(board, 'd4')).to include 'e5'
      expect(FindMoves.call(board, 'd4')).not_to include 'f6'

      board.place_piece(white_pawn, 'b2')
      expect(FindMoves.call(board, 'd4')).to include 'c3'
      expect(FindMoves.call(board, 'd4')).not_to include 'b2'

      board.place_piece(white_pawn, 'b6')
      expect(FindMoves.call(board, 'd4')).to include 'c5'
      expect(FindMoves.call(board, 'd4')).not_to include 'b6'

      board.place_piece(white_pawn, 'f2')
      expect(FindMoves.call(board, 'd4')).to include 'e3'
      expect(FindMoves.call(board, 'd4')).not_to include 'f2'
      expect(FindMoves.call(board, 'd4')).not_to include 'd4'
    end

    it "lets a piece capture another piece" do
      board.place_piece(black_pawn, 'f6')
      expect(FindMoves.call(board, 'd4')).to include 'e5'
      expect(FindMoves.call(board, 'd4')).to include 'f6'
      expect(FindMoves.call(board, 'd4')).not_to include 'g7'

      board.place_piece(black_pawn, 'b2')
      expect(FindMoves.call(board, 'd4')).to include 'c3'
      expect(FindMoves.call(board, 'd4')).to include 'b2'
      expect(FindMoves.call(board, 'd4')).not_to include 'a1'

      board.place_piece(black_pawn, 'b6')
      expect(FindMoves.call(board, 'd4')).to include 'c5'
      expect(FindMoves.call(board, 'd4')).to include 'b6'
      expect(FindMoves.call(board, 'd4')).not_to include 'a7'

      board.place_piece(black_pawn, 'f2')
      expect(FindMoves.call(board, 'd4')).to include 'e3'
      expect(FindMoves.call(board, 'd4')).to include 'f2'
      expect(FindMoves.call(board, 'd4')).not_to include 'g1'
      expect(FindMoves.call(board, 'd4')).not_to include 'd4'
    end
  end

  describe 'knight moves' do
    it 'knows where a knight can move' do
      board.place_piece(black_knight, 'd4')
      expect(FindMoves.call(board, 'd4').sort).to eq %w[b3 b5 c2 c6 e2 e6 f3 f5]

      board.place_piece(black_pawn, 'b3')
      board.place_piece(white_pawn, 'b5')

      expect(FindMoves.call(board, 'd4')).to include 'b5'
      expect(FindMoves.call(board, 'd4')).not_to include 'b3'
    end
  end
end
