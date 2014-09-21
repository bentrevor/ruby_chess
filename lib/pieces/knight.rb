require './lib/pieces/piece'

class Knight < Piece
  def initialize(color)
    self.directions = [:knight]
    self.color      = color
    self.abbrev     = 'n'
  end
end
