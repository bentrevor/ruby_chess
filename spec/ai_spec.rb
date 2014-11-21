require 'spec_helper'

describe AI do
  let(:rules)  { Rules }
  let(:player) { Player.new(double('decider'), :black) }
  let(:board)  { Board.new({'a1' => black_king, 'h2' => white_king}) }

  let(:ai) { AI.new(double(:get_move => Move.new('a1 - a2'))) }

  it 'gets a move from its strategy' do
    move = ai.get_move(rules)

    expect(move.text).to start_with 'a1 - '
    # expect(['a2', 'b2', 'b1']).to include move[-2..-1]
  end
end
