class Strategy
  def self.score_board(board, rules, player)
    winner = rules.winner(board)

    if winner
      return (winner == player.color) ? 10000 : -10000
    end

    pieces = board.pieces.values.select { |p| p.color == player.color }

    pieces.map { |p| piece_scores[p.abbrev] }.reduce(:+)
  end

  private

  def self.piece_scores
    {
      'p' => 1,
      'n' => 3,
      'b' => 3,
      'r' => 5,
      'q' => 9
    }
  end
end
