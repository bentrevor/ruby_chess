require 'board'

describe EchoBoard do
  it 'starts as an empty string' do
    EchoBoard.new.spaces.should == ''
  end

  it 'appends to the string each turn' do
    board = EchoBoard.new
    board.place_move('yolo')
    board.spaces.should == 'yolo'
    board.place_move('swag')
    board.spaces.should == 'yoloswag'
  end
end

describe Board do
  it 'has 64 spaces' do
    board = Board.new
    board.spaces.length.should == 64
  end
end
