require './lib/pieces/piece'

class Pawn < Piece
  def initialize(color)
    self.color      = color
    self.directions = pawn_directions
    self.abbrev     = 'p'
  end

  def limit(rank)
    (on_home_rank?(rank)) ? 2 : 1
  end

  def on_home_rank?(rank)
    home_rank = (color == :white) ? 2 : 7

    rank == home_rank
  end

  private

  def pawn_directions
    (color == :white) ? [:north] : [:south]
  end
end
