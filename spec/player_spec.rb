require 'player'

describe Player do
  specify 'human players use input to decide a move' do
    input = double 'input'
    player = Player.new input

    input.should_receive :get_move

    player.get_move
  end

  specify 'computer players use ai to decide a move' do
    ai = double 'ai'
    player = Player.new ai

    ai.should_receive :get_move

    player.get_move
  end
end
