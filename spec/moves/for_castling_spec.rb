require 'spec_helper'

describe Moves::ForCastling do
  let(:black_bishop) { Piece.create :black, :bishop }
  let(:black_king)   { Piece.create :black, :king }
  let(:black_knight) { Piece.create :black, :knight }
  let(:black_pawn)   { Piece.create :black, :pawn }
  let(:black_rook)   { Piece.create :black, :rook }
  let(:white_bishop) { Piece.create :white, :bishop }
  let(:white_king)   { Piece.create :white, :king }
  let(:white_pawn)   { Piece.create :white, :pawn }
  let(:white_rook)   { Piece.create :white, :rook }
  let(:rules)        { Rules }

  let(:board) { Board.new({ 'a1' => white_rook,
                            'h1' => white_rook,
                            'e1' => white_king,

                            'a8' => black_rook,
                            'h8' => black_rook,
                            'e8' => black_king }) }

  let(:player1) { Player.new(double, :white) }
  let(:player2) { Player.new(double, :black) }

  it 'lets a player castle when no pieces are in the way' do
    expect(Moves::ForCastling.for(board, player1, rules).sort).to eq ['e1 - c1', 'e1 - g1']
    expect(Moves::ForCastling.for(board, player2, rules).sort).to eq ['e8 - c8', 'e8 - g8']
  end

  it "doesn't let a player castle if there are pieces in the way" do
    board.place_piece(white_bishop, 'b1')
    board.place_piece(white_bishop, 'f1')
    board.place_piece(white_bishop, 'c8')
    board.place_piece(white_bishop, 'g8')

    expect(Moves::ForCastling.for(board, player1, rules).sort).to eq []
    expect(Moves::ForCastling.for(board, player2, rules).sort).to eq []
  end

  it "doesn't let a player castle if they have moved their king or rook" do
    player1.can_castle_left  = false
    player1.can_castle_right = false
    player2.can_castle_left  = false
    player2.can_castle_right = false

    expect(Moves::ForCastling.for(board, player1, rules).sort).to eq []
    expect(Moves::ForCastling.for(board, player2, rules).sort).to eq []
  end

  it "doesn't let a player castle out of check" do
    board.place_piece(white_bishop, 'a4')
    board.place_piece(black_bishop, 'a5')

    expect(Moves::ForCastling.for(board, player1, rules).sort).to eq []
    expect(Moves::ForCastling.for(board, player2, rules).sort).to eq []
  end

  it "doesn't let a player castle through check" do
    board.place_piece(white_bishop, 'e7')
    board.place_piece(black_knight, 'e3')

    expect(Moves::ForCastling.for(board, player1, rules).sort).to eq []
    expect(Moves::ForCastling.for(board, player2, rules).sort).to eq []
  end

  specify "a player can't castle into check" do
    board.place_piece(black_rook, 'g3')

    expect(Moves::ForCastling.for(board, player1, rules)).to eq ['e1 - c1']
  end

  specify 'a player can sometimes only castle to one side' do
    player1.can_castle_left = false
    player2.can_castle_right = false

    expect(Moves::ForCastling.for(board, player1, rules).sort).to eq ['e1 - g1']
    expect(Moves::ForCastling.for(board, player2, rules).sort).to eq ['e8 - c8']
  end

  specify "a player can't castle without a rook" do
    board.place_piece(nil, 'a1')
    board.place_piece(nil, 'h1')

    expect(Moves::ForCastling.for(board, player1, Rules).sort).to eq []
  end
end
