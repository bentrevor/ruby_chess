require './lib/pieces/piece'

class Queen < Piece
  def initialize(color)
    self.directions = ALL_DIRECTIONS
    self.color      = color
    self.abbrev     = 'q'
  end

  def limit(rank)
    7
  end
end
