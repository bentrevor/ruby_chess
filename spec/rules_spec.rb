require 'rules'

describe EchoRules do
  def board(spaces)
    double 'board', :spaces => spaces
  end

  it 'knows when a game is over' do

    EchoRules.game_over?(board('yolo')).should == false
    EchoRules.game_over?(board('swaggy')).should == true
  end

  it 'knows the winner' do
    EchoRules.winner.should == :nobody
  end

  specify 'every move is valid' do
    EchoRules.valid_move?(board('swag')).should == true
  end
end
