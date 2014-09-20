require './lib/pieces/piece'

class Pawn < Piece
  def initialize(color)
    self.color      = color
    self.directions = pawn_directions
    self.limit      = 1
    self.abbrev     = 'p'
  end

  private

  def pawn_directions
    if color == :white
      [:north]
    else
      [:south]
    end
  end
end