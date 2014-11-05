class AI
  attr_accessor :strategy

  def initialize(strategy)
    self.strategy = strategy
  end

  def get_move(board, rules, player)
    spaces = board.pieces.select { |_, piece| piece.color == player.color }.keys

    moves = spaces.map do |space|
      rules.all_moves_for_space(space, board, player)
    end.flatten

    scored_moves = {}

    moves.each do |move|
      score = strategy.score_move(move, board, rules, player)

      scored_moves[score.to_s] ||= Array.new
      scored_moves[score.to_s] << move
    end

    best_score = scored_moves.keys.max
    scored_moves[best_score].sample
  end
end
