require 'pieces/piece'

class Bishop < Piece
  def initialize(color)
    self.directions = DIAGONAL_DIRECTIONS
    self.limit      = 8
    self.color      = color
  end
end
