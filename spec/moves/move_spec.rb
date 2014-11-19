require 'spec_helper'

describe Move do
  it 'has a starting space and target space' do
    move = Move.new('a2 - a4')

    expect(move.starting_space).to eq 'a2'
    expect(move.target_space).to eq 'a4'
  end

  it 'has a type' do
    move = Move.new('a2 - a4')
    expect(move.type).to eq :normal

    move = Move.new('e1 c g1')
    expect(move.type).to eq :castle

    move = Move.new('e7 q e8')
    expect(move.type).to eq :promotion
  end

  it 'is comparable' do
    move1 = Move.new('e7 q e8')
    move2 = Move.new('e7 q e8')
    expect(move1 == move2).to be true
  end
end
