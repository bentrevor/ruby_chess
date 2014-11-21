require 'spec_helper'

describe Board do
  let(:board) { Board.new }

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
    queen = black_queen
    board.place_piece(queen, 'd4')

    expect(board.pieces['d4']).to be queen
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

    expect(board.pieces['a1']).to eq black_rook
    expect(board.pieces['b1']).to eq white_bishop
    expect(board.pieces['h3']).to eq black_queen
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

  it 'can castle' do
    board = Board.new({ :e1 => white_king,
                        :h1 => white_rook })

    board.move_piece(Move.new('e1 c g1'))
    expect(board.pieces['g1']).to be_a King
    expect(board.pieces['f1']).to be_a Rook
    expect(board.pieces['h1']).to be nil
  end
end
