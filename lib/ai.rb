class AI
  attr_accessor :strategy

  def initialize(strategy)
    self.strategy = strategy
  end

  def get_move(board, rules, player)
    strategy.get_move(board, rules, player)
  end
end
