require 'spec_helper'

describe Moves::Castling do
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

  it 'lets a player castle when no pieces are in the way' do
    expect(Moves::Castling.for(board, player1, ChessRules).sort).to eq ['c1', 'g1']
    expect(Moves::Castling.for(board, player2, ChessRules).sort).to eq ['c8', 'g8']
  end

  it "doesn't let a player castle if there are pieces in the way" do
    board.place_piece(white_bishop, 'b1')
    board.place_piece(white_bishop, 'f1')
    board.place_piece(white_bishop, 'c8')
    board.place_piece(white_bishop, 'g8')

    expect(Moves::Castling.for(board, player1, ChessRules).sort).to eq []
    expect(Moves::Castling.for(board, player2, ChessRules).sort).to eq []
  end

  it "doesn't let a player castle if they have moved their king or rook" do
    player1.can_castle_left  = false
    player1.can_castle_right = false
    player2.can_castle_left  = false
    player2.can_castle_right = false

    expect(Moves::Castling.for(board, player1, ChessRules).sort).to eq []
    expect(Moves::Castling.for(board, player2, ChessRules).sort).to eq []
  end

  it "doesn't let a player castle out of check" do
    board.place_piece(white_bishop, 'a4')
    board.place_piece(black_bishop, 'a5')

    expect(Moves::Castling.for(board, player1, ChessRules).sort).to eq []
    expect(Moves::Castling.for(board, player2, ChessRules).sort).to eq []
  end

  it "doesn't let a player castle through check" do
    board.place_piece(white_bishop, 'e7')
    board.place_piece(black_knight, 'e3')

    expect(Moves::Castling.for(board, player1, ChessRules).sort).to eq []
    expect(Moves::Castling.for(board, player2, ChessRules).sort).to eq []
  end

  # regression specs
  specify "a player can't castle into check" do
    board.place_piece(black_rook, 'g3')

    expect(Moves::Castling.for(board, player1, ChessRules)).to eq ['c1']
  end

  specify 'a player can sometimes only castle to one side' do
    player1.can_castle_left = false
    player2.can_castle_right = false

    expect(Moves::Castling.for(board, player1, ChessRules).sort).to eq ['g1']
    expect(Moves::Castling.for(board, player2, ChessRules).sort).to eq ['c8']
  end
end
