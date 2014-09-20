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
end
