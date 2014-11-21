require 'spec_helper'

describe Moves::ForKnight do
  let(:board)        { Board.new({}) }

  def moves_for(space)
    Moves::ForKnight.for(board, space).map(&:text).sort
  end

  it 'knows where a knight can move' do
    board.place_piece(black_knight, 'd4')

    knight_moves = Moves::ForKnight.for(board, 'd4')
    target_spaces = knight_moves.map(&:target_space)

    expect(target_spaces.sort).to eq %w[b3 b5 c2 c6 e2 e6 f3 f5]

    board.place_piece(black_pawn, 'b3')
    board.place_piece(white_pawn, 'b5')

    expect(moves_for('d4')).to include 'd4 - b5'
    expect(moves_for('d4')).not_to include 'd4 - b3'
  end

  it 'strips target spaces with a rank of 10' do
    # a validation expects rank and file each to be one digit

    board.place_piece(black_knight, 'h8')
    expect(moves_for('h8')).not_to include 'h8 - g10'
    expect(moves_for('h8')).not_to include 'h8 - i10'
  end

  # regression spec
  specify 'only knights have knight moves' do
    board.place_piece(black_pawn, 'h8')
    expect(moves_for('h8')).to be_empty
  end
end
