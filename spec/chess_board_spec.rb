require 'spec_helper'

describe ChessBoard do
  let(:board) { ChessBoard.new }
  let(:black_rook) { Piece.create(:black, :rook) }
  let(:white_bishop) { Piece.create(:white, :bishop) }
  let(:black_queen) { Piece.create(:black, :queen) }


  it 'has 64 spaces' do
    expect(board.spaces.length).to eq 64
  end

  it 'can start with only some pieces' do
    board = ChessBoard.new({ :a1 => black_rook })
    expect(board.pieces['a1']).to be_a Rook
    expect(board.pieces['a1'].color).to eq :black
  end

  it 'uses the initial setup if no starting pieces are given' do
    expect(board.pieces['a1']).to be_a Rook
    expect(board.pieces['a1'].color).to eq :white
    expect(board.pieces['a2']).to be_a Pawn
    expect(board.pieces['a2'].color).to eq :white

    expect(board.pieces['a7']).to be_a Pawn
    expect(board.pieces['a7'].color).to eq :black
    expect(board.pieces['a8']).to be_a Rook
    expect(board.pieces['a8'].color).to eq :black
  end

  it 'raises an error if it gets the wrong format move' do
    expect { board.move_piece('a1') }.to raise_error(ArgumentError)
  end

  it 'can move a piece' do
    board.move_piece 'a2 - a4'

    expect(board.pieces['a2']).to be nil
    expect(board.pieces['a4']).to be_a Pawn
  end

  it 'can capture a piece' do
    board = ChessBoard.new({ :a1 => black_rook,
                             :a2 => white_bishop })

    board.move_piece 'a1 - a2'

    expect(board.pieces['a1']).to be nil
    expect(board.pieces['a2']).to be_a Rook
  end

  it 'can place a piece' do
    board.place_piece(black_queen, 'd4')

    expect(board.pieces['d4']).to be black_queen
  end

  it 'can try/undo a move' do
    board = ChessBoard.new({ :a1 => black_rook,
                             :a2 => white_bishop })

    board.try_move('a1 - a2') do
      expect(board.pieces['a1']).to be_nil
      expect(board.pieces['a2']).to be_a Rook
    end

    expect(board.pieces['a1']).to be_a Rook
    expect(board.pieces['a2']).to be_a Bishop
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
