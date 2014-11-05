require './lib/strategy'

class BestSingleMove < Strategy
  def self.get_move(board, rules, player)
    moves = rules.all_moves_for_player(player, board)
    scored_moves = {}

    moves.each do |move|
      score = score_move(move, board, rules, player)

      scored_moves[score.to_s] ||= Array.new
      scored_moves[score.to_s] << move
    end

    best_score = scored_moves.keys.max

    scored_moves[best_score].sample
  end

  private

  def self.score_move(move, board, rules, player)
    score = 0

    board.try_move(move) do
      score = score_board(board, rules, player)
    end

    score
  end
end
