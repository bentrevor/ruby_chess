class AI
  attr_accessor :strategy

  def initialize(strategy)
    self.strategy = strategy
  end

  def get_move(rules)
    strategy.get_move(rules)
  end
end
