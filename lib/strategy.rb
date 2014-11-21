class Strategy
  class << self
    def score_board(board, rules, player)
      winner = rules.winner

      if winner
        return (winner == player.color) ? 10000 : -10000
      end

      pieces_score(board, player)
    end

    def pieces_score(board, player)
      all_pieces      = board.pieces.values
      player_pieces   = all_pieces.select { |p| p.color == player.color }
      opponent_pieces = all_pieces.select { |p| p.color != player.color }

      player_score   = player_pieces.map { |p| piece_scores[p.abbrev] }.reduce(:+)   || 0
      opponent_score = opponent_pieces.map { |p| piece_scores[p.abbrev] }.reduce(:+) || 0

      player_score - opponent_score
    end

    private

    def piece_scores
      {
        'p' => 1,
        'n' => 3,
        'b' => 3,
        'r' => 5,
        'q' => 9,
        'k' => 0
      }
    end
  end
end
