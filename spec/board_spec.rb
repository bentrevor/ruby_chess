require 'spec_helper'

describe ChessBoard do
  let(:board) { ChessBoard.new }

  it 'has 64 spaces' do
    board.spaces.length.should == 64
  end

  it 'can start with only some pieces' do
    board = ChessBoard.new({:a1 => PieceFactory.create(:black, :rook)})
    board.piece_at('a1').should be_a Rook
    board.piece_at('a1').color.should == :black
  end

  it 'uses the initial setup if no starting pieces are given' do
    board.piece_at('a1').should be_a Rook
    board.piece_at('a1').color.should == :white
    board.piece_at('a2').should be_a Pawn
    board.piece_at('a2').color.should == :white

    board.piece_at('a7').should be_a Pawn
    board.piece_at('a7').color.should == :black
    board.piece_at('a8').should be_a Rook
    board.piece_at('a8').color.should == :black
  end

  it 'can make a move' do
    move = 'a2 - a4'
    board.place_move move

    board.piece_at('a2').should be nil
    board.piece_at('a4').should be_a Pawn
  end
end
