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
    non_diagonal = [:north, :east, :south, :west]
    diagonal = [:northeast, :northwest, :southeast, :southwest]
    all_directions = diagonal + non_diagonal
    {
      :rook => non_diagonal,
      :bishop => diagonal,
      :queen => all_directions,
      :king => all_directions,
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
