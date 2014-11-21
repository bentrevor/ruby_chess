class RandomMove
  def self.get_move(rules)
    rules.all_moves_for_player.sample
  end
end
