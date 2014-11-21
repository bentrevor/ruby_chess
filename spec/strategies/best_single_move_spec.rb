require 'spec_helper'

xdescribe BestSingleMove do
  it 'picks the best immediate move' do
    rules = Rules
    board = Board.new({ 'a4' => black_rook,
                        'h4' => white_pawn,
                        'a2' => white_bishop })

    player = Player.new(double, :black)

    expect(BestSingleMove.get_move(board, rules, player)).to eq 'a4 - a2'

    board.place_piece(white_queen, 'a6')
    expect(BestSingleMove.get_move(board, rules, player)).to eq 'a4 - a6'
  end
end
