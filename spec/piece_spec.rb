require 'piece'

describe Piece do
  let(:rook) { Piece.new :rook, :black }
  let(:bishop) { Piece.new :bishop, :black }
  let(:queen) { Piece.new :queen, :black }
  let(:king) { Piece.new :king, :black }
  let(:knight) { Piece.new :knight, :black }
  let(:pawn) { Piece.new :pawn, :black }

  it 'has a type and color' do
    rook.type.should == :rook
    rook.color.should == :black
  end

  it 'knows how to move' do
    rook.directions.should include :north
    rook.directions.should include :south
    rook.directions.should include :east
    rook.directions.should include :west

    bishop.directions.should include :northeast
    bishop.directions.should include :northwest
    bishop.directions.should include :southeast
    bishop.directions.should include :southwest

    queen.directions.should include :north
    queen.directions.should include :south
    queen.directions.should include :east
    queen.directions.should include :west
    queen.directions.should include :northeast
    queen.directions.should include :northwest
    queen.directions.should include :southeast
    queen.directions.should include :southwest

    king.directions.should include :north
    king.directions.should include :south
    king.directions.should include :east
    king.directions.should include :west
    king.directions.should include :northeast
    king.directions.should include :northwest
    king.directions.should include :southeast
    king.directions.should include :southwest
  end

  it 'knows how far it can move' do
    king.limit.should == 1
    pawn.limit.should == 1
    queen.limit.should == 8
  end
end
