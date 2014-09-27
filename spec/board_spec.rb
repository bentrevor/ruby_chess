require 'spec_helper'

describe ChessBoard do
  let(:board) { ChessBoard.new }
  let(:black_rook) { PieceFactory.create(:black, :rook) }
  let(:white_bishop) { PieceFactory.create(:white, :bishop) }
  let(:black_queen) { PieceFactory.create(:black, :queen) }


  it 'has 64 spaces' do
    expect(board.spaces.length).to eq 64
  end

  it 'can start with only some pieces' do
    board = ChessBoard.new({:a1 => black_rook })
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

  it 'can move a piece' do
    board.move_piece 'a2 - a4'

    expect(board.get_piece('a2')).to be nil
    expect(board.get_piece('a4')).to be_a Pawn
  end

  it 'can place a piece' do
    board.place_piece(black_queen, 'd4')

    expect(board.get_piece('d4')).to be black_queen
  end

  it 'lists all pieces' do
    board = ChessBoard.new({ :a1 => black_rook,
                             :b1 => white_bishop,
                             :h3 => black_queen })

    expect(board.pieces['a1']).to be black_rook
    expect(board.pieces['b1']).to be white_bishop
    expect(board.pieces['h3']).to be black_queen
  end
end
