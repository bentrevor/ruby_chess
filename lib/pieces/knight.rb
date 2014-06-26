require 'pieces/piece'

class Knight < Piece
  def initialize(color)
    self.directions = [:knight]
    self.limit      = 0
    self.color      = color
  end
end
