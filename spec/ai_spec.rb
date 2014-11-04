require 'spec_helper'

describe AI do
  let(:black_king) { Piece.create :black, :king }
  let(:white_king) { Piece.create :white, :king }
  let(:rules) { Rules }
  let(:player) { Player.new(double('decider'), :black) }
  let(:board) { Board.new({'a1' => black_king, 'h2' => white_king}) }

  it 'returns a move' do
    move = AI.get_move(board, rules, player)
    expect(move).to start_with 'a1 - '
    expect(['a2', 'b2', 'b1']).to include move[-2..-1]
  end
end
