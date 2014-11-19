require 'spec_helper'

describe Moves::ForPawn do
  let(:black_rook)   { Piece.create :black, :rook }
  let(:black_pawn)   { Piece.create :black, :pawn }
  let(:white_rook)   { Piece.create :white, :rook }
  let(:white_pawn)   { Piece.create :white, :pawn }
  let(:board)        { Board.new({}) }

  def moves_for(space)
    Moves::ForPawn.for(board, space).map(&:text).sort
  end

  it 'knows where a pawn can move' do
    board.place_piece(white_pawn, 'd2')
    expect(moves_for('d2')).to eq ['d2 - d3', 'd2 - d4']

    board.place_piece(black_pawn, 'b5')
    expect(moves_for('b5')).to eq ['b5 - b4']
  end

  it 'knows that non-pawns have no pawn moves' do
    board.place_piece(black_rook, 'd2')
    expect(moves_for('d2')).to be_empty
  end

  it 'knows where a pawn can capture' do
    board.place_piece(white_pawn, 'd2')
    board.place_piece(black_rook, 'c3')
    board.place_piece(white_rook, 'e3')

    expect(moves_for('d2')).to include 'd2 - c3'
    expect(moves_for('d2')).not_to include 'd2 - e3'

    board.place_piece(black_pawn, 'e7')
    board.place_piece(black_rook, 'd6')
    board.place_piece(white_rook, 'f6')

    expect(moves_for('e7')).to include 'e7 - f6'
    expect(moves_for('e7')).not_to include 'e7 - d6'
  end

  it 'knows where a pawn can not capture' do
    board.place_piece(white_pawn, 'd2')
    board.place_piece(black_rook, 'd3')

    expect(moves_for('d2')).not_to include 'd2 - d3'
  end
end
