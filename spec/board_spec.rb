require 'spec_helper'

describe Board do
  let(:board) { Board.new }

  let(:black_rook)   { Piece.create(:black, :rook) }
  let(:black_queen)  { Piece.create(:black, :queen) }
  let(:white_pawn)   { Piece.create(:white, :pawn) }
  let(:white_bishop) { Piece.create(:white, :bishop) }


  it 'has 64 spaces' do
    expect(board.spaces.length).to eq 64
  end

  it 'can start with only some pieces' do
    board = Board.new({ :a1 => black_rook })
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
    expect { board.move_piece(Move.new('a1')) }.to raise_error(ArgumentError)
  end

  it 'can move a piece' do
    board.move_piece(Move.new('a2 - a4'))

    expect(board.pieces['a2']).to be nil
    expect(board.pieces['a4']).to be_a Pawn
  end

  it 'can capture a piece' do
    board = Board.new({ :a1 => black_rook,
                        :a2 => white_bishop })

    board.move_piece(Move.new('a1 - a2'))

    expect(board.pieces['a1']).to be nil
    expect(board.pieces['a2']).to be_a Rook
  end

  it 'can place a piece' do
    board.place_piece(black_queen, 'd4')

    expect(board.pieces['d4']).to be black_queen
  end

  it 'can try/undo a move' do
    board = Board.new({ :a1 => black_rook,
                        :a2 => white_bishop })

    board.try_move(Move.new('a1 - a2')) do
      expect(board.pieces['a1']).to be_nil
      expect(board.pieces['a2']).to be_a Rook
    end

    expect(board.pieces['a1']).to be_a Rook
    expect(board.pieces['a2']).to be_a Bishop
  end

  it 'lists all pieces' do
    board = Board.new({ :a1 => black_rook,
                        :b1 => white_bishop,
                        :h3 => black_queen })

    expect(board.pieces['a1']).to be black_rook
    expect(board.pieces['b1']).to be white_bishop
    expect(board.pieces['h3']).to be black_queen
  end

  it 'can move in a direction' do
    expect(board.move_in_direction('d4', :north)).to eq 'd5'
    expect(board.move_in_direction('d4', :northeast)).to eq 'e5'
    expect(board.move_in_direction('d4', :east)).to eq 'e4'
    expect(board.move_in_direction('d4', :southeast)).to eq 'e3'
    expect(board.move_in_direction('d4', :south)).to eq 'd3'
    expect(board.move_in_direction('d4', :southwest)).to eq 'c3'
    expect(board.move_in_direction('d4', :west)).to eq 'c4'
    expect(board.move_in_direction('d4', :northwest)).to eq 'c5'
  end

  it 'can promote a pawn' do
    board = Board.new({ :d7 => white_pawn,
                        :e8 => black_queen })

    board.move_piece(Move.new('d7 k d8'))
    expect(board.pieces['d8']).to be_a Knight
  end
end
