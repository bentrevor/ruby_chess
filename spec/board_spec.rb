require 'board'
require 'piece'
require 'pry'

describe ChessBoard do
  let(:board) { ChessBoard.new }

  it 'has 64 spaces' do
    board.spaces.length.should == 64
  end

  it 'starts with pieces in some of the spaces' do
    board.spaces[0..15].should be_all { |x| x.is_a? Piece }
    board.spaces[16..47].should be_all { |x| x.nil? }
    board.spaces[48..63].should be_all { |x| x.is_a? Piece }
  end
end

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
