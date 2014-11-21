require 'spec_helper'

describe ValidateMove do
  let(:board)   { Board.new({ 'd4' => white_rook,
                            'c3' => black_rook }) }
  let(:player1) { Player.new(double, :white) }
  let(:player2) { Player.new(double, :black) }
  let(:rules)   { Rules.new(board, player1, player2) }

  let(:validate_move) { described_class.new(rules) }

  it 'knows when a move is valid' do
    expect(validate_move.call(Move.new('d4 - d5'))).to eq true
  end

  it 'is false when there is no piece in original space' do
    expect { validate_move.call(Move.new('a4 - a5')) }.to raise_error(Rules::InvalidMoveError)
  end

  it 'is false when it tries to move the wrong color piece' do
    expect { validate_move.call(Move.new('c3 - c4')) }.to raise_error(Rules::InvalidMoveError)
  end

  it 'is false when it tries to make an illegal move' do
    expect(  validate_move.call(Move.new('d4 - d8'))).to eq true
    expect(  validate_move.call(Move.new('d4 - h4'))).to eq true
    expect { validate_move.call(Move.new('d4 - e5')) }.to raise_error(Rules::InvalidMoveError)
  end

  it 'raises an error when a pawn promotion is not specified' do
    board = Board.new({ :d7 => white_pawn })
    rules = Rules.new(board, player1, player2)
    validate_move = described_class.new(rules)

    expect { validate_move.call(Move.new('d7 - d8')) }.to raise_error(Rules::InvalidMoveError)
    expect(  validate_move.call(Move.new('d7 k d8'))).to eq true
    expect(  validate_move.call(Move.new('d7 b d8'))).to eq true
    expect(  validate_move.call(Move.new('d7 r d8'))).to eq true
    expect(  validate_move.call(Move.new('d7 q d8'))).to eq true
  end

  it "doesn't let you move into check" do
    board.place_piece(white_king, 'b2')
    rules = Rules.new(board, player1, player2)
    validate_move = described_class.new(rules)

    %w[a3 b3 c2 c1].each do |invalid_move|
      expect { validate_move.call(Move.new("b2 - #{invalid_move}")) }.to raise_error(Rules::InvalidMoveError)
    end

    %w[a2 a1 b1 c3].each do |valid_move|
      expect(validate_move.call(Move.new("b2 - #{valid_move}"))).to eq true
    end
  end

  it 'forces you to move out of check' do
    board.place_piece(white_king, 'c2')

    expect { validate_move.call(Move.new('c2 - c1')) }.to raise_error(Rules::InvalidMoveError)
    expect { validate_move.call(Move.new('d4 - e4')) }.to raise_error(Rules::InvalidMoveError)

    expect(  validate_move.call(Move.new('c2 - b2'))).to eq true
    expect(  validate_move.call(Move.new('c2 - d1'))).to eq true
    expect(  validate_move.call(Move.new('c2 - c3'))).to eq true
  end

  it 'only promotes a pawn when it is moving to the last rank' do
    board = Board.new({ :a7 => white_pawn,
                        :a2 => white_pawn,
                        :b6 => white_pawn })

    rules = Rules.new(board, player1, player2)
    validate_move = described_class.new(rules)

    expect(validate_move.call(Move.new('a7 k a8'))).to be true
    expect { validate_move.call(Move.new('b6 k b7')) }.to raise_error(Rules::InvalidMoveError)
  end
end
