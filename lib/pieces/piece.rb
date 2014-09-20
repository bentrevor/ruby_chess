class Piece
  attr_accessor :abbrev, :color, :directions, :limit

  DIAGONAL_DIRECTIONS = [:northeast, :northwest, :southeast, :southwest]
  NON_DIAGONAL_DIRECTIONS = [:north, :east, :south, :west]
  ALL_DIRECTIONS = DIAGONAL_DIRECTIONS + NON_DIAGONAL_DIRECTIONS

  def initialize(color)
    self.color = color
  end
end
