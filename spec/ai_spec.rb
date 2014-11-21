require 'spec_helper'

xdescribe AI do
  let(:rules)  { Rules }
  let(:player) { Player.new(double('decider'), :black) }
  let(:board)  { Board.new({'a1' => black_king, 'h2' => white_king}) }

  let(:ai) { AI.new(BestSingleMove) }

  it 'returns a move' do
    move = ai.get_move(board, rules, player)

    expect(move).to start_with 'a1 - '
    expect(['a2', 'b2', 'b1']).to include move[-2..-1]
  end
end
