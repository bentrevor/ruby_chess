require './lib/pieces/piece'

class Queen < Piece
  def initialize(color)
    self.directions = ALL_DIRECTIONS
    self.limit      = 8
    self.color      = color
    self.abbrev     = 'q'
  end
end
