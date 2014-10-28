require 'spec_helper'

describe Moves::ForPawn do
  let(:black_rook)   { Piece.create :black, :rook }
  let(:black_pawn)   { Piece.create :black, :pawn }
  let(:white_rook)   { Piece.create :white, :rook }
  let(:white_pawn)   { Piece.create :white, :pawn }
  let(:board)        { ChessBoard.new({}) }

  it 'knows where a pawn can move' do
    board.place_piece(white_pawn, 'd2')
    expect(Moves::ForPawn.for(board, 'd2').sort).to eq %w[d3 d4]

    board.place_piece(black_pawn, 'b5')
    expect(Moves::ForPawn.for(board, 'b5')).to eq %w[b4]
  end

  it 'knows that non-pawns have no pawn moves' do
    board.place_piece(black_rook, 'd2')
    expect(Moves::ForPawn.for(board, 'd2')).to be_empty
  end

  it 'knows where a pawn can capture' do
    board.place_piece(white_pawn, 'd2')
    board.place_piece(black_rook, 'c3')
    board.place_piece(white_rook, 'e3')

    expect(Moves::ForPawn.for(board, 'd2')).to include 'c3'
    expect(Moves::ForPawn.for(board, 'd2')).not_to include 'e3'

    board.place_piece(black_pawn, 'e7')
    board.place_piece(black_rook, 'd6')
    board.place_piece(white_rook, 'f6')

    expect(Moves::ForPawn.for(board, 'e7')).to include 'f6'
    expect(Moves::ForPawn.for(board, 'e7')).not_to include 'd6'
  end
end
