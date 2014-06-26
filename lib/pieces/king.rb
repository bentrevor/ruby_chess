require 'pieces/piece'

class King < Piece
  def initialize(color)
    self.directions = ALL_DIRECTIONS
    self.limit      = 1
    self.color      = color
  end
end
