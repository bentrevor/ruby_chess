class RandomMove
  def self.get_move(rules)
    move = rules.all_moves_for_player.sample

    if promoting_pawn?(move, rules)
      Move.new(move.text.gsub('-', 'q'))
    else
      move
    end
  end

  def self.promoting_pawn?(move, rules)
    rules.board.pieces[move.starting_space].is_a?(Pawn) &&
      move.target_space[1] =~ /[18]/
  end
end
