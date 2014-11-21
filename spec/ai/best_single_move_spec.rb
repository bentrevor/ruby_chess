require 'spec_helper'

describe BestSingleMove do
  let(:board)   { Board.new({ 'a1' => white_rook,
                              'b1' => black_bishop }) }
  let(:player1) { Player.new(double, :white) }
  let(:player2) { Player.new(double, :black) }
  let(:rules)   { Rules.new(board, player1, player2) }

  it 'gets the best immediate move' do
    expect(BestSingleMove.get_move(rules).text).to eq 'a1 - b1'

    board.place_piece(black_queen, 'a5')

    expect(BestSingleMove.get_move(rules).text).to eq 'a1 - a5'
  end
end
