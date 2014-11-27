class BestSingleMove
  def self.get_move(rules)
    new(rules).get_move
  end

  attr_accessor :rules

  def initialize(rules)
    self.rules = rules
  end

  def get_move
    scores = {}

    rules.all_moves_for_player.each do |move|
      rules.board.try_move(move) do
        scores[move.text] = score_board(rules.board)
      end
    end

    begin
    Move.new(best_move_from(scores))
      rescue
      binding.pry
      end
  end

  def best_move_from(scores)
    best_score = scores.values.min

    best_move = scores.select { |_, score| score == best_score }.keys.sample

    if pawn_promotion?(best_move)
      best_move.gsub('-', 'q')
    else
      best_move
    end
  end

  def pawn_promotion?(move)
    move &&
    rules.board.pieces[move[0..1]].is_a?(Pawn) &&
      move[-1] =~ /[18]/
  end

  def score_board(board)
    other_player_pieces = board.pieces.values.select do |piece|
      piece.color == rules.other_player.color
    end

    other_player_pieces.map { |piece| score_piece(piece) }.reduce(:+) || 0
  end

  def score_piece(piece)
    {
      'p' => 1,
      'n' => 3,
      'b' => 3,
      'r' => 5,
      'q' => 9,
      'k' => 0
    }[piece.abbrev]
  end
end
