require 'spec_helper'

describe Moves::ForPawn do
  let(:black_rook)   { Piece.create :black, :rook }
  let(:black_pawn)   { Piece.create :black, :pawn }
  let(:white_rook)   { Piece.create :white, :rook }
  let(:white_pawn)   { Piece.create :white, :pawn }
  let(:board)        { Board.new({}) }

  it 'knows where a pawn can move' do
    board.place_piece(white_pawn, 'd2')
    expect(Moves::ForPawn.for(board, 'd2').sort).to eq ['d2 - d3', 'd2 - d4']

    board.place_piece(black_pawn, 'b5')
    expect(Moves::ForPawn.for(board, 'b5')).to eq ['b5 - b4']
  end

  it 'knows that non-pawns have no pawn moves' do
    board.place_piece(black_rook, 'd2')
    expect(Moves::ForPawn.for(board, 'd2')).to be_empty
  end

  it 'knows where a pawn can capture' do
    board.place_piece(white_pawn, 'd2')
    board.place_piece(black_rook, 'c3')
    board.place_piece(white_rook, 'e3')

    expect(Moves::ForPawn.for(board, 'd2')).to include 'd2 - c3'
    expect(Moves::ForPawn.for(board, 'd2')).not_to include 'd2 - e3'

    board.place_piece(black_pawn, 'e7')
    board.place_piece(black_rook, 'd6')
    board.place_piece(white_rook, 'f6')

    expect(Moves::ForPawn.for(board, 'e7')).to include 'e7 - f6'
    expect(Moves::ForPawn.for(board, 'e7')).not_to include 'e7 - d6'
  end

  it 'knows where a pawn can not capture' do
    board.place_piece(white_pawn, 'd2')
    board.place_piece(black_rook, 'd3')

    expect(Moves::ForPawn.for(board, 'd2')).not_to include 'd2 - d3'
  end
end
