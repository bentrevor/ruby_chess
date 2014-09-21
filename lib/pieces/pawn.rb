require './lib/pieces/piece'

class Pawn < Piece
  def initialize(color)
    self.color      = color
    self.directions = pawn_directions
    self.abbrev     = 'p'
  end

  def limit(rank)
    home_rank = if color == :white
                  2
                else
                  7
                end

    if rank == home_rank
      2
      else
      1
    end
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
