require 'spec_helper'

describe ChessBoard do
  let(:board) { ChessBoard.new }

  it 'has 64 spaces' do
    board.spaces.length.should == 64
  end

  it 'starts with pieces in some of the spaces' do
    board.piece_at('a1').type.should == :rook
    board.piece_at('a1').color.should == :white
    board.piece_at('a2').type.should == :pawn
    board.piece_at('a2').color.should == :white

    board.piece_at('a7').type.should == :pawn
    board.piece_at('a7').color.should == :black
    board.piece_at('a8').type.should == :rook
    board.piece_at('a8').color.should == :black
  end

  it 'can make a move' do
    move = 'a2 - a4'
    board.place_move move

    board.piece_at('a2').should be nil
    board.piece_at('a4').type.should be :pawn
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
