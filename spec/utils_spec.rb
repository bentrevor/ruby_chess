require 'spec_helper'

describe Utils do
  it 'knows when a move is correctly formatted' do
    expect(Utils.correctly_formatted_move?(Move.new('a1 - a2'))).to be true
    expect(Utils.correctly_formatted_move?(Move.new('a1-a2'))).to be false
    expect(Utils.correctly_formatted_move?(Move.new('yolo'))).to be false
    expect(Utils.correctly_formatted_move?(Move.new('-------'))).to be false
    expect(Utils.correctly_formatted_move?(Move.new('x1 - x2'))).to be false
  end

  it 'can convert target spaces into moves' do
    starting_space = 'a1'
    target_spaces  = %w[a2 b1 b2]

    expect(Utils.spaces_to_moves(target_spaces, starting_space).map(&:text).sort).to eq ['a1 - a2', 'a1 - b1', 'a1 - b2']
  end
end
