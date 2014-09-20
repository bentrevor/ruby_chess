require 'spec_helper'

describe Piece do
  let(:rook)   { PieceFactory.create :black, :rook }
  let(:bishop) { PieceFactory.create :black, :bishop }
  let(:queen)  { PieceFactory.create :black, :queen }
  let(:king)   { PieceFactory.create :black, :king }
  let(:knight) { PieceFactory.create :black, :knight }
  let(:pawn)   { PieceFactory.create :black, :pawn }

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
    expect(king.limit).to eq 1
    expect(pawn.limit).to eq 1
    expect(queen.limit).to eq 8
  end
end
