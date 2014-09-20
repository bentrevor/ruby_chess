class Player
  attr_accessor :color

  def initialize(move_decider)
    @decider = move_decider
  end

  def get_move
    @decider.get_move
  end
end
