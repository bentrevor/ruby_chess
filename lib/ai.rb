class AI
  def self.get_move(board, rules, player)
    spaces = board.pieces.select do |space, piece|
      piece.color == player.color
    end.keys

    all_moves = {}

    spaces.each do |space|
      all_moves[space] = Moves.for(board, space, player, rules)
    end

    starting_space = all_moves.keys.sample
    target_space = all_moves[starting_space].sample

    "#{starting_space} - #{target_space}"
  end
end
