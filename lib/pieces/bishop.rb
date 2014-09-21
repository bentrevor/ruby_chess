require './lib/pieces/piece'

class Bishop < Piece
  def initialize(color)
    self.directions = DIAGONAL_DIRECTIONS
    self.color      = color
    self.abbrev     = 'b'
  end

  def limit(rank)
    7
  end
end
