class KnightMoves
  class << self
    def by_bob_seger(board, starting_space)
      file = starting_space[0]
      rank = starting_space[1].to_i

      l_moves(file, rank).select do |space|
        space.length == 2 and
          !off_board?(space[0], space[1].to_i) and
          !colliding(board, starting_space, space)
      end
    end

    def l_moves(file, rank)
      ["#{decf(decf(file))}#{rank - 1}", "#{decf(decf(file))}#{rank + 1}",
       "#{decf(file)}#{rank - 2}",       "#{decf(file)}#{rank + 2}",
       "#{incf(incf(file))}#{rank - 1}", "#{incf(incf(file))}#{rank + 1}",
       "#{incf(file)}#{rank - 2}",       "#{incf(file)}#{rank + 2}"]
    end

    def incf(file)
      (file.ord + 1).chr
    end

    def decf(file)
      (file.ord - 1).chr
    end

    def off_board?(file, rank)
      file < 'a' or file > 'h' or rank < 1 or rank > 8
    end

    def colliding(board, starting_space, target_space)
      starting_piece = board.pieces[starting_space]
      target_piece = board.pieces[target_space]

      if target_piece and starting_piece and target_piece.color == starting_piece.color
        true
      else
        false
      end
    end
  end
end
