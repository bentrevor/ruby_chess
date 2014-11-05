require './lib/strategy'

class RandomMove < Strategy
  def self.get_move(board, rules, player)
    moves = rules.all_moves_for_player(player, board)

    moves.sample
  end
end
