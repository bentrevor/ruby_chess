class Player
  attr_accessor :color, :can_castle_left, :can_castle_right, :decider

  def initialize(move_decider, color)
    self.decider = move_decider
    self.can_castle_left  = true
    self.can_castle_right = true
    self.color = color
  end

  def get_move(board, rules)
    decider.get_move(board, rules, self)
  end

  def pause
    gets
  end
end
