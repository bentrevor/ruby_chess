require 'spec_helper'

describe Player do
  specify 'human players use input to decide a move' do
    input = double 'input'
    player = Player.new input

    expect(input).to receive :get_move

    player.get_move
  end

  specify 'computer players use ai to decide a move' do
    ai = double 'ai'
    player = Player.new ai

    expect(ai).to receive :get_move

    player.get_move
  end
end
