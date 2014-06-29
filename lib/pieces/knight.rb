require 'pieces/piece'

class Knight < Piece
  def initialize(color)
    self.directions = [:knight]
    self.limit      = 0
    self.color      = color
    self.abbrev     = 'n'
  end
end
