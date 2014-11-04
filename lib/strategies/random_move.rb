require './lib/strategy'
class RandomMove < Strategy
  def self.score_move(move, board, rules, player)
    1
  end
end
