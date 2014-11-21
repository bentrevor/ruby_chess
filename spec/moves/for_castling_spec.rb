require 'spec_helper'

describe Moves::ForCastling do
  let(:board) { Board.new({ 'a1' => white_rook,
                            'h1' => white_rook,
                            'e1' => white_king,

                            'a8' => black_rook,
                            'h8' => black_rook,
                            'e8' => black_king }) }

  let(:player1) { Player.new(double, :white) }
  let(:player2) { Player.new(double, :black) }

  let(:rules)   { Rules.new(board, player1, player2) }

  def moves_for(player)
    other_player = if player == player1
                     player2
                   else
                     player1
                   end

    Moves::ForCastling.for(Rules.new(board, player, other_player)).map(&:text).sort
  end

  it 'lets a player castle when no pieces are in the way' do
    expect(moves_for(player1)).to eq ['e1 c c1', 'e1 c g1']
    expect(moves_for(player2)).to eq ['e8 c c8', 'e8 c g8']
  end

  it "doesn't let a player castle if there are pieces in the way" do
    board.place_piece(white_bishop, 'b1')
    board.place_piece(white_bishop, 'f1')
    board.place_piece(white_bishop, 'c8')
    board.place_piece(white_bishop, 'g8')

    expect(moves_for(player1)).to eq []
    expect(moves_for(player2)).to eq []
  end

  it "doesn't let a player castle if they have moved their king or rook" do
    player1.can_castle_left  = false
    player2.can_castle_left  = false

    expect(moves_for(player1)).to eq ['e1 c g1']
    expect(moves_for(player2)).to eq ['e8 c g8']

    player1.can_castle_right  = false
    player2.can_castle_right = false

    expect(moves_for(player1)).to eq []
    expect(moves_for(player2)).to eq []
  end

  it "doesn't let a player castle out of check" do
    board.place_piece(white_bishop, 'a4')
    board.place_piece(black_bishop, 'a5')

    expect(moves_for(player1)).to eq []
    expect(moves_for(player2)).to eq []
  end

  it "doesn't let a player castle through check" do
    board.place_piece(white_bishop, 'e7')
    board.place_piece(black_knight, 'e3')

    expect(moves_for(player1)).to eq []
    expect(moves_for(player2)).to eq []
  end

  specify "a player can't castle into check" do
    board.place_piece(black_rook, 'g3')

    expect(moves_for(player1)).to eq ['e1 c c1']
  end

  specify 'a player can sometimes only castle to one side' do
    player1.can_castle_left = false
    player2.can_castle_right = false

    expect(moves_for(player1)).to eq ['e1 c g1']
    expect(moves_for(player2)).to eq ['e8 c c8']
  end

  specify "a player can't castle without a rook" do
    board.place_piece(nil, 'a1')
    board.place_piece(nil, 'h1')

    expect(moves_for(player1)).to eq []
  end
end
