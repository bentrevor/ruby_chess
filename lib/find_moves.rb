class FindMoves
  class << self
    def call(board, starting_space)
      moves = []
      piece = board.pieces[starting_space]

      piece.directions.each do |direction|
        moves << remaining_spaces_for(board, direction, starting_space)
      end

      moves.flatten
    end

    def remaining_spaces_for(board, direction, current_space)
      moving_piece = board.pieces[current_space]
      return knight_spaces(board, current_space) if moving_piece.class == Knight

      spaces = []
      file = current_space[0]
      rank = current_space[1].to_i
      moves_so_far = 1
      move_limit = moving_piece.limit(rank)

      case direction
      when :north
        rank += 1
        until invalid?(file, rank, moves_so_far, move_limit)
          if target_piece = board.pieces["#{file}#{rank}"]
            piece_collision(moving_piece, target_piece, "#{file}#{rank}", spaces)
            break
          else
            moves_so_far += 1
            spaces, file, rank = add_space(spaces, file, rank, {:rank_change => :inc,
                                             :file_change => :none})
          end
        end
      when :south
        rank -= 1
        until invalid?(file, rank, moves_so_far, move_limit)
          if target_piece = board.pieces["#{file}#{rank}"]
            piece_collision(moving_piece, target_piece, "#{file}#{rank}", spaces)
            break
          else
            moves_so_far += 1
            spaces, file, rank = add_space(spaces, file, rank, {:rank_change => :dec,
                                             :file_change => :none})
          end
        end
      when :east
        file = incf(file)
        until invalid?(file, rank, moves_so_far, move_limit)
          if target_piece = board.pieces["#{file}#{rank}"]
            piece_collision(moving_piece, target_piece, "#{file}#{rank}", spaces)
            break
          else
            moves_so_far += 1
            spaces, file, rank = add_space(spaces, file, rank, {:rank_change => :none,
                                             :file_change => :inc})
          end
        end
      when :west
        file = decf(file)
        until invalid?(file, rank, moves_so_far, move_limit)
          if target_piece = board.pieces["#{file}#{rank}"]
            piece_collision(moving_piece, target_piece, "#{file}#{rank}", spaces)
            break
          else
            moves_so_far += 1
            spaces, file, rank = add_space(spaces, file, rank, {:rank_change => :none,
                                             :file_change => :dec})
          end
        end
      when :northeast
        rank += 1
        file = incf(file)
        until invalid?(file, rank, moves_so_far, move_limit)
          if target_piece = board.pieces["#{file}#{rank}"]
            piece_collision(moving_piece, target_piece, "#{file}#{rank}", spaces)
            break
          else
            moves_so_far += 1
            spaces, file, rank = add_space(spaces, file, rank, {:rank_change => :inc,
                                             :file_change => :inc})
          end
        end
      when :northwest
        rank += 1
        file = decf(file)
        until invalid?(file, rank, moves_so_far, move_limit)
          if target_piece = board.pieces["#{file}#{rank}"]
            piece_collision(moving_piece, target_piece, "#{file}#{rank}", spaces)
            break
          else
            moves_so_far += 1
            spaces, file, rank = add_space(spaces, file, rank, {:rank_change => :inc,
                                             :file_change => :dec})
          end
        end
      when :southeast
        rank -= 1
        file = incf(file)
        until invalid?(file, rank, moves_so_far, move_limit)
          if target_piece = board.pieces["#{file}#{rank}"]
            piece_collision(moving_piece, target_piece, "#{file}#{rank}", spaces)
            break
          else
            moves_so_far += 1
            spaces, file, rank = add_space(spaces, file, rank, {:rank_change => :dec,
                                             :file_change => :inc})
          end
        end
      when :southwest
        rank -= 1
        file = decf(file)
        until invalid?(file, rank, moves_so_far, move_limit)
          if target_piece = board.pieces["#{file}#{rank}"]
            piece_collision(moving_piece, target_piece, "#{file}#{rank}", spaces)
            break
          else
            moves_so_far += 1
            spaces, file, rank = add_space(spaces, file, rank, {:rank_change => :dec,
                                             :file_change => :dec})
          end
        end
      end

      spaces
    end

    def piece_collision(moving_piece, target_piece, current_space, spaces)
      if moving_piece.color == target_piece.color
        spaces
      else
        spaces.push current_space
      end
    end

    def incf(file)
      (file.ord + 1).chr
    end

    def decf(file)
      (file.ord - 1).chr
    end

    def add_space(spaces, file, rank, changes)
      spaces << "#{file}#{rank}"
      case changes[:rank_change]
      when :inc
        rank += 1
      when :dec
        rank -= 1
      end

      case changes[:file_change]
      when :inc
        file = incf(file)
      when :dec
        file = decf(file)
      end

      [spaces, file, rank]
    end

    def invalid?(file, rank, moves_so_far, move_limit)
      off_board?(file, rank) or moves_so_far > move_limit
    end

    def off_board?(file, rank)
      file < 'a' or file > 'h' or rank < 1 or rank > 8
    end

    def knight_spaces(board, starting_space)
      file = starting_space[0]
      rank = starting_space[1].to_i

      l_moves(file, rank).select do |space|
        space.length == 2 and
          !off_board?(space[0], space[1].to_i) and
          !colliding(board, starting_space, space)
      end
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

    def l_moves(file, rank)
      ["#{decf(decf(file))}#{rank - 1}", "#{decf(decf(file))}#{rank + 1}",
       "#{decf(file)}#{rank - 2}",       "#{decf(file)}#{rank + 2}",
       "#{incf(incf(file))}#{rank - 1}", "#{incf(incf(file))}#{rank + 1}",
       "#{incf(file)}#{rank - 2}",       "#{incf(file)}#{rank + 2}"]
    end
  end
end
