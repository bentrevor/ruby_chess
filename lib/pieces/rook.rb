require './lib/pieces/piece'

class Rook < Piece
  def initialize(color)
    self.directions = NON_DIAGONAL_DIRECTIONS
    self.limit      = 8
    self.color      = color
    self.abbrev     = 'r'
  end
end