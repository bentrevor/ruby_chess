require 'spec_helper'

describe CastleMoves do
  let(:black_bishop) { Piece.create :black, :bishop }
  let(:black_king)   { Piece.create :black, :king }
  let(:black_knight) { Piece.create :black, :knight }
  let(:black_pawn)   { Piece.create :black, :pawn }
  let(:black_rook)   { Piece.create :black, :rook }
  let(:white_bishop) { Piece.create :white, :bishop }
  let(:white_king)   { Piece.create :white, :king }
  let(:white_pawn)   { Piece.create :white, :pawn }
  let(:white_rook)   { Piece.create :white, :rook }

  let(:board) { ChessBoard.new({ 'a1' => white_rook,
                                 'h1' => white_rook,
                                 'e1' => white_king,

                                 'a8' => black_rook,
                                 'h8' => black_rook,
                                 'e8' => black_king }) }

  let(:player1) { Player.new(double, :white) }
  let(:player2) { Player.new(double, :black) }

  specify 'a player can castle when no pieces are in the way' do
    expect(CastleMoves.for(board, 'e1', player1, ChessRules).sort).to eq ['c1', 'g1']
    expect(CastleMoves.for(board, 'e8', player2, ChessRules).sort).to eq ['c8', 'g8']
  end

  specify "a player can't castle if there are pieces in the way" do
    board.place_piece(white_bishop, 'b1')
    board.place_piece(white_bishop, 'f1')
    board.place_piece(white_bishop, 'c8')
    board.place_piece(white_bishop, 'g8')

    expect(CastleMoves.for(board, 'e1', player1, ChessRules).sort).to eq []
    expect(CastleMoves.for(board, 'e8', player2, ChessRules).sort).to eq []
  end

  specify "a player can't castle if they have moved their king or rook" do
    player1.can_castle_left  = false
    player1.can_castle_right = false
    player2.can_castle_left  = false
    player2.can_castle_right = false

    expect(CastleMoves.for(board, 'e1', player1, ChessRules).sort).to eq []
    expect(CastleMoves.for(board, 'e8', player2, ChessRules).sort).to eq []
  end

  specify "a player can't castle out of check" do
    board.place_piece(white_bishop, 'a4')
    board.place_piece(black_bishop, 'a5')

    expect(CastleMoves.for(board, 'e1', player1, ChessRules).sort).to eq []
    expect(CastleMoves.for(board, 'e8', player2, ChessRules).sort).to eq []
  end

  specify "a player can't castle through check" do
    board.place_piece(white_bishop, 'e7')
    board.place_piece(black_knight, 'e3')

    expect(CastleMoves.for(board, 'e1', player1, ChessRules).sort).to eq []
    expect(CastleMoves.for(board, 'e8', player2, ChessRules).sort).to eq []
  end
end
