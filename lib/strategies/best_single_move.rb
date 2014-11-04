require './lib/strategy'

class BestSingleMove < Strategy
  def self.score_move(move, board, rules, player)
    score = 0

    board.try_move(move) do
      score = score_board(board, rules, player)
    end

    score
  end
end
