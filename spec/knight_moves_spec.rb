require 'spec_helper'

describe KnightMoves do
  let(:black_knight) { Piece.create :black, :knight }
  let(:black_pawn)   { Piece.create :black, :pawn }
  let(:white_pawn)   { Piece.create :white, :pawn }
  let(:board) { ChessBoard.new({}) }

  it 'knows where a knight can move' do
    board.place_piece(black_knight, 'd4')
    expect(KnightMoves.by_bob_seger(board, 'd4').sort).to eq %w[b3 b5 c2 c6 e2 e6 f3 f5]

    board.place_piece(black_pawn, 'b3')
    board.place_piece(white_pawn, 'b5')

    expect(KnightMoves.by_bob_seger(board, 'd4')).to include 'b5'
    expect(KnightMoves.by_bob_seger(board, 'd4')).not_to include 'b3'
  end

  it 'strips target spaces with a rank of 10' do
    # a validation expects rank and file each to be one digit

    board.place_piece(black_knight, 'h8')
    expect(KnightMoves.by_bob_seger(board, 'h8')).not_to include 'g10'
    expect(KnightMoves.by_bob_seger(board, 'h8')).not_to include 'i10'
  end
end
