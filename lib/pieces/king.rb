require './lib/pieces/piece'

class King < Piece
  def initialize(color)
    self.directions = ALL_DIRECTIONS
    self.color      = color
    self.abbrev     = 'k'
  end

  def limit(rank)
    1
  end
end
