require 'spec_helper'

describe Moves::ForLinearPiece do
  let(:board) { Board.new({'d4' => white_rook}) }

  def moves_for(space)
    Moves::ForLinearPiece.for(board, space).map(&:text).sort
  end

  describe 'horizontal/vertical moves' do
    it 'knows what moves are legal for a piece' do
      [1,2,3,5,6,7,8].each do |rank|
        expect(moves_for('d4')).to include "d4 - d#{rank}"
      end

      %w[a b c e f g h].each do |file|
        expect(moves_for('d4')).to include "d4 - #{file}4"
      end
    end

    it 'limits the length of moves' do
      board.place_piece(black_king, 'd4')

      %w[c5 d5 e5 e4 e3 d3 c3 c4].each do |space|
        expect(moves_for('d4')).to include "d4 - #{space}"
      end

      %w[b6 d6 f6 f4 f2 d2 b2 b4].each do |space|
        expect(moves_for('d4')).not_to include "d4 - #{space}"
      end
    end

    it "doesn't let a piece move through a teammate" do
      board.place_piece(white_pawn, 'd6')
      expect(moves_for('d4')).to include 'd4 - d5'
      expect(moves_for('d4')).not_to include 'd4 - d6'

      board.place_piece(white_pawn, 'd2')
      expect(moves_for('d4')).to include 'd4 - d3'
      expect(moves_for('d4')).not_to include 'd4 - d2'

      board.place_piece(white_pawn, 'b4')
      expect(moves_for('d4')).to include 'd4 - c4'
      expect(moves_for('d4')).not_to include 'd4 - b4'

      board.place_piece(white_pawn, 'f4')
      expect(moves_for('d4')).to include 'd4 - e4'
      expect(moves_for('d4')).not_to include 'd4 - f4'
    end

    it "lets a piece capture another piece" do
      board.place_piece(black_pawn, 'd6')
      expect(moves_for('d4')).to include 'd4 - d5'
      expect(moves_for('d4')).to include 'd4 - d6'
      expect(moves_for('d4')).not_to include 'd4 - d7'

      board.place_piece(black_pawn, 'd2')
      expect(moves_for('d4')).to include 'd4 - d3'
      expect(moves_for('d4')).to include 'd4 - d2'
      expect(moves_for('d4')).not_to include 'd4 - d1'

      board.place_piece(black_pawn, 'b4')
      expect(moves_for('d4')).to include 'd4 - c4'
      expect(moves_for('d4')).to include 'd4 - b4'
      expect(moves_for('d4')).not_to include 'd4 - a4'

      board.place_piece(black_pawn, 'f4')
      expect(moves_for('d4')).to include 'd4 - e4'
      expect(moves_for('d4')).to include 'd4 - f4'
      expect(moves_for('d4')).not_to include 'd4 - g4'
    end
  end

  describe 'diagonal #moves_for' do
    let(:board) { Board.new({'d4' => white_bishop}) }

    it 'knows what moves are legal for a diagonally-moving piece' do
      %w[a1 b2 c3 e5 f6 g7 h8 a7 b6 c5 e3 f2 g1].each do |space|
        expect(moves_for('d4')).to include "d4 - #{space}"
      end
    end

    it "doesn't let a piece move through a teammate" do
      board.place_piece(white_pawn, 'f6')
      expect(moves_for('d4')).to include 'd4 - e5'
      expect(moves_for('d4')).not_to include 'd4 - f6'

      board.place_piece(white_pawn, 'b2')
      expect(moves_for('d4')).to include 'd4 - c3'
      expect(moves_for('d4')).not_to include 'd4 - b2'

      board.place_piece(white_pawn, 'b6')
      expect(moves_for('d4')).to include 'd4 - c5'
      expect(moves_for('d4')).not_to include 'd4 - b6'

      board.place_piece(white_pawn, 'f2')
      expect(moves_for('d4')).to include 'd4 - e3'
      expect(moves_for('d4')).not_to include 'd4 - f2'
      expect(moves_for('d4')).not_to include 'd4 - d4'
    end

    it "lets a piece capture another piece" do
      board.place_piece(black_pawn, 'f6')
      expect(moves_for('d4')).to include 'd4 - e5'
      expect(moves_for('d4')).to include 'd4 - f6'
      expect(moves_for('d4')).not_to include 'd4 - g7'

      board.place_piece(black_pawn, 'b2')
      expect(moves_for('d4')).to include 'd4 - c3'
      expect(moves_for('d4')).to include 'd4 - b2'
      expect(moves_for('d4')).not_to include 'd4 - a1'

      board.place_piece(black_pawn, 'b6')
      expect(moves_for('d4')).to include 'd4 - c5'
      expect(moves_for('d4')).to include 'd4 - b6'
      expect(moves_for('d4')).not_to include 'd4 - a7'

      board.place_piece(black_pawn, 'f2')
      expect(moves_for('d4')).to include 'd4 - e3'
      expect(moves_for('d4')).to include 'd4 - f2'
      expect(moves_for('d4')).not_to include 'd4 - g1'
    end
  end

  it 'returns an empty list for a knight and pawn' do
    board.place_piece(black_knight, 'd4')
    board.place_piece(black_pawn, 'e4')
    expect(moves_for('d4')).to be_empty
    expect(moves_for('e4')).to be_empty
  end

  it 'only lists spaces on the board' do
    board.place_piece(black_king, 'd1')

    expect(moves_for('d1')).not_to include 'd1 - d0'
    expect(moves_for('d1').length).to eq 5
  end

  it 'knows how a queen moves' do
    queen_moves = Moves::ForLinearPiece.for(Board.new, 'd8').map(&:text).sort

    expect(queen_moves).not_to include 'd8 - g2'
  end
end
