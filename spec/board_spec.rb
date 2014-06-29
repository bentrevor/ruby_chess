require 'spec_helper'

describe ChessBoard do
  let(:board) { ChessBoard.new }

  it 'has 64 spaces' do
    board.spaces.length.should == 64
  end

  it 'can start with only some pieces' do
    board = ChessBoard.new({:a1 => PieceFactory.create(:black, :rook)})
    board.get_piece('a1').should be_a Rook
    board.get_piece('a1').color.should == :black
  end

  it 'uses the initial setup if no starting pieces are given' do
    board.get_piece('a1').should be_a Rook
    board.get_piece('a1').color.should == :white
    board.get_piece('a2').should be_a Pawn
    board.get_piece('a2').color.should == :white

    board.get_piece('a7').should be_a Pawn
    board.get_piece('a7').color.should == :black
    board.get_piece('a8').should be_a Rook
    board.get_piece('a8').color.should == :black
  end

  it 'can make a move' do
    move = 'a2 - a4'
    board.make_move move

    board.get_piece('a2').should be nil
    board.get_piece('a4').should be_a Pawn
  end

  it 'can format itself to print to a console' do
    printable_board = board.formatted_for_console.lines

    printable_board.first.should == " br | bn | bb | bq | bk | bb | bn | br \n"
    printable_board.should include "----+----+----+----+----+----+----+----\n"
    printable_board.should include "    |    |    |    |    |    |    |    \n"
    printable_board.should include " wp | wp | wp | wp | wp | wp | wp | wp \n"
    printable_board.should include " wr | wn | wb | wq | wk | wb | wn | wr \n"
    printable_board.should include " bp | bp | bp | bp | bp | bp | bp | bp \n"
  end
end
