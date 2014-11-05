require 'spec_helper'

describe BestSingleMove do
  it 'picks the best immediate move' do
    rules = Rules
    board = Board.new({ 'a4' => Piece.create(:black, :rook),
                        'h4' => Piece.create(:white, :pawn),
                        'a2' => Piece.create(:white, :bishop) })

    player = Player.new(double, :black)

    expect(BestSingleMove.get_move(board, rules, player)).to eq 'a4 - a2'

    board.place_piece(Piece.create(:white, :queen), 'a6')
    expect(BestSingleMove.get_move(board, rules, player)).to eq 'a4 - a6'
  end
end
