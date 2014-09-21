require './lib/pieces/piece'

class Rook < Piece
  def initialize(color)
    self.directions = NON_DIAGONAL_DIRECTIONS
    self.color      = color
    self.abbrev     = 'r'
  end

  def limit(rank)
    7
  end
end
