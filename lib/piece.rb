class Piece
  attr_accessor :type, :color, :directions, :limit

  def initialize(type, color)
    self.type       = type
    self.color      = color
    self.directions = directions_for type
    self.limit = limit_for type
  end

  private

  def directions_for(type)
    {
      :rook => [:north, :east, :south, :west],
      :bishop => [:northeast, :northwest, :southeast, :southwest],
      :queen => [:north, :east, :south, :west, :northeast, :northwest, :southeast, :southwest],
      :king => [:north, :east, :south, :west, :northeast, :northwest, :southeast, :southwest],
      :pawn => pawn_directions,
      :knight => :not_sure_yet
    }[type]
  end

  def limit_for(type)
    {
      :king => 1,
      :pawn => 1
    }[type] || 8
  end

  def pawn_directions
    if color == :white
      [:north]
    else
      [:south]
    end
  end
end
