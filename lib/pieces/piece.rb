class Piece
  attr_accessor :abbrev, :color, :directions

  DIAGONAL_DIRECTIONS = [:northeast, :northwest, :southeast, :southwest]
  NON_DIAGONAL_DIRECTIONS = [:north, :east, :south, :west]
  ALL_DIRECTIONS = DIAGONAL_DIRECTIONS + NON_DIAGONAL_DIRECTIONS

  def self.create(color, type)
    case type
    when :rook
      Rook.new(color)
    when :bishop
      Bishop.new(color)
    when :pawn
      Pawn.new(color)
    when :king
      King.new(color)
    when :queen
      Queen.new(color)
    when :knight
      Knight.new(color)
    end
  end

  def ==(other)
    color == other.color && abbrev == other.abbrev
  end
end
