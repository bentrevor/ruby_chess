require 'spec_helper'

describe ChessBoard do
  let(:board) { ChessBoard.new }

  it 'has 64 spaces' do
    expect(board.spaces.length).to eq 64
  end

  it 'can start with only some pieces' do
    board = ChessBoard.new({:a1 => PieceFactory.create(:black, :rook)})
    expect(board.get_piece('a1')).to be_a Rook
    expect(board.get_piece('a1').color).to eq :black
  end

  it 'uses the initial setup if no starting pieces are given' do
    expect(board.get_piece('a1')).to be_a Rook
    expect(board.get_piece('a1').color).to eq :white
    expect(board.get_piece('a2')).to be_a Pawn
    expect(board.get_piece('a2').color).to eq :white

    expect(board.get_piece('a7')).to be_a Pawn
    expect(board.get_piece('a7').color).to eq :black
    expect(board.get_piece('a8')).to be_a Rook
    expect(board.get_piece('a8').color).to eq :black
  end

  it 'can make a move' do
    move = 'a2 - a4'
    board.make_move move

    expect(board.get_piece('a2')).to be nil
    expect(board.get_piece('a4')).to be_a Pawn
  end

  it 'can format itself to print to a console' do
    printable_board = board.formatted_for_console.lines

    expect(printable_board.first).to eq " br | bn | bb | bq | bk | bb | bn | br \n"
    expect(printable_board).to include "----+----+----+----+----+----+----+----\n"
    expect(printable_board).to include "    |    |    |    |    |    |    |    \n"
    expect(printable_board).to include " wp | wp | wp | wp | wp | wp | wp | wp \n"
    expect(printable_board).to include " wr | wn | wb | wq | wk | wb | wn | wr \n"
    expect(printable_board).to include " bp | bp | bp | bp | bp | bp | bp | bp \n"
  end
end
