class AI
  attr_accessor :strategy

  def initialize(strategy)
    self.strategy = strategy
  end

  def get_move(board, rules, player)
    spaces = board.pieces.select do |space, piece|
      piece.color == player.color
    end.keys

    moves = []

    spaces.each do |space|
      Moves.for(board, space, player, rules).each do |target_space|
        moves << "#{space} - #{target_space}"
      end
    end

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
