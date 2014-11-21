require 'spec_helper'

describe Piece do
  let(:rook)   { Piece.create :black, :rook }
  let(:bishop) { Piece.create :black, :bishop }
  let(:queen)  { Piece.create :black, :queen }
  let(:king)   { Piece.create :black, :king }
  let(:knight) { Piece.create :black, :knight }
  let(:pawn)   { Piece.create :black, :pawn }

  it 'knows how to move' do
    expect(rook.directions).to include :north
    expect(rook.directions).to include :south
    expect(rook.directions).to include :east
    expect(rook.directions).to include :west

    expect(bishop.directions).to include :northeast
    expect(bishop.directions).to include :northwest
    expect(bishop.directions).to include :southeast
    expect(bishop.directions).to include :southwest

    expect(queen.directions).to include :north
    expect(queen.directions).to include :south
    expect(queen.directions).to include :east
    expect(queen.directions).to include :west
    expect(queen.directions).to include :northeast
    expect(queen.directions).to include :northwest
    expect(queen.directions).to include :southeast
    expect(queen.directions).to include :southwest

    expect(king.directions).to include :north
    expect(king.directions).to include :south
    expect(king.directions).to include :east
    expect(king.directions).to include :west
    expect(king.directions).to include :northeast
    expect(king.directions).to include :northwest
    expect(king.directions).to include :southeast
    expect(king.directions).to include :southwest
  end

  it 'knows how far it can move' do
    expect(king.limit(0)).to eq 1
    expect(pawn.limit(7)).to eq 2
    expect(pawn.limit(6)).to eq 1
    expect(queen.limit(8)).to eq 7
  end

  it 'is equatable' do
    rook1 = Piece.create(:black, :rook)
    rook2 = Piece.create(:black, :rook)

    expect(rook1).to eq rook2
  end
end
