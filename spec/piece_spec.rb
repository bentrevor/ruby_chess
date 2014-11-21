require 'spec_helper'

describe Piece do
  it 'knows how to move' do
    expect(black_rook.directions).to include :north
    expect(black_rook.directions).to include :south
    expect(black_rook.directions).to include :east
    expect(black_rook.directions).to include :west

    expect(black_bishop.directions).to include :northeast
    expect(black_bishop.directions).to include :northwest
    expect(black_bishop.directions).to include :southeast
    expect(black_bishop.directions).to include :southwest

    expect(black_queen.directions).to include :north
    expect(black_queen.directions).to include :south
    expect(black_queen.directions).to include :east
    expect(black_queen.directions).to include :west
    expect(black_queen.directions).to include :northeast
    expect(black_queen.directions).to include :northwest
    expect(black_queen.directions).to include :southeast
    expect(black_queen.directions).to include :southwest

    expect(black_king.directions).to include :north
    expect(black_king.directions).to include :south
    expect(black_king.directions).to include :east
    expect(black_king.directions).to include :west
    expect(black_king.directions).to include :northeast
    expect(black_king.directions).to include :northwest
    expect(black_king.directions).to include :southeast
    expect(black_king.directions).to include :southwest
  end

  it 'knows how far it can move' do
    expect(black_king.limit(0)).to eq 1
    expect(black_pawn.limit(7)).to eq 2
    expect(black_pawn.limit(6)).to eq 1
    expect(black_queen.limit(8)).to eq 7
  end

  it 'is equatable' do
    rook1 = Piece.create(:black, :rook)
    rook2 = Piece.create(:black, :rook)

    expect(rook1).to eq rook2
  end
end
