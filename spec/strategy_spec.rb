require 'spec_helper'

describe Strategy do
  let(:strategy) { described_class }
  let(:board) { Board.new({}) }
  let(:rules) { Rules }
  let(:player1) { Player.new(double('ai'), :white) }
  let(:player2) { Player.new(double('ai'), :black) }

  context 'scoring pieces' do
    {
      :pawn   => 1,
      :knight => 3,
      :bishop => 3,
      :rook   => 5,
      :queen  => 9
    }.each do |piece, points|
      it "knows a #{piece} is worth #{points} points" do
        board.place_piece(Piece.create(:black, piece), 'd4')

        expect(strategy.score_board(board, rules, player2)).to eq points
      end
    end

    it 'subtracts opponent pieces' do
      board.place_piece(Piece.create(:black, :queen), 'a1')  # 9
      board.place_piece(Piece.create(:black, :knight), 'a2') # 3

      board.place_piece(Piece.create(:white, :pawn), 'a3')   # 1
      board.place_piece(Piece.create(:white, :rook), 'a4')   # 5
      board.place_piece(Piece.create(:white, :bishop), 'a5') # 3
      board.place_piece(Piece.create(:white, :knight), 'a6') # 3

      expect(strategy.score_board(board, rules, player1)).to eq 0
      expect(strategy.score_board(board, rules, player2)).to eq 0
    end
  end

  it 'scores a win as 10000' do
    # arbitrary number for now, not sure what the scale will end up being
    # expect(rules).to receive(:game_over?).and_return true
    expect(rules).to receive(:winner).and_return :black

    expect(strategy.score_board(board, rules, player2)).to eq 10000
  end
end
