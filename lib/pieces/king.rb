require './lib/pieces/piece'

class King < Piece
  def initialize(color)
    self.directions = ALL_DIRECTIONS
    self.limit      = 1
    self.color      = color
    self.abbrev     = 'k'
  end
end
