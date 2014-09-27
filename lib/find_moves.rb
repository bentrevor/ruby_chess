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
      return [] if moving_piece.class == Knight

      spaces = []
      file = current_space[0]
      rank = current_space[1].to_i
      moves_so_far = 1
      move_limit = moving_piece.limit(rank)

      case direction
      when :north
        rank += 1
        until invalid?(rank, file, moves_so_far, move_limit)
          if target_piece = board.pieces["#{file}#{rank}"]
            piece_collision(moving_piece, target_piece, "#{file}#{rank}", spaces)
            break
          else
            moves_so_far += 1
            spaces, rank, file = add_space(spaces, rank, file, {:rank_change => :inc,
                                             :file_change => :none})
          end
        end
      when :south
        rank -= 1
        until invalid?(rank, file, moves_so_far, move_limit)
          if target_piece = board.pieces["#{file}#{rank}"]
            piece_collision(moving_piece, target_piece, "#{file}#{rank}", spaces)
            break
          else
            moves_so_far += 1
            spaces, rank, file = add_space(spaces, rank, file, {:rank_change => :dec,
                                             :file_change => :none})
          end
        end
      when :east
        file = incf(file)
        until invalid?(rank, file, moves_so_far, move_limit)
          if target_piece = board.pieces["#{file}#{rank}"]
            piece_collision(moving_piece, target_piece, "#{file}#{rank}", spaces)
            break
          else
            moves_so_far += 1
            spaces, rank, file = add_space(spaces, rank, file, {:rank_change => :none,
                                             :file_change => :inc})
          end
        end
      when :west
        file = decf(file)
        until invalid?(rank, file, moves_so_far, move_limit)
          if target_piece = board.pieces["#{file}#{rank}"]
            piece_collision(moving_piece, target_piece, "#{file}#{rank}", spaces)
            break
          else
            moves_so_far += 1
            spaces, rank, file = add_space(spaces, rank, file, {:rank_change => :none,
                                             :file_change => :dec})
          end
        end
      when :northeast
        rank += 1
        file = incf(file)
        until invalid?(rank, file, moves_so_far, move_limit)
          if target_piece = board.pieces["#{file}#{rank}"]
            piece_collision(moving_piece, target_piece, "#{file}#{rank}", spaces)
            break
          else
            moves_so_far += 1
            spaces, rank, file = add_space(spaces, rank, file, {:rank_change => :inc,
                                             :file_change => :inc})
          end
        end
      when :northwest
        rank += 1
        file = decf(file)
        until invalid?(rank, file, moves_so_far, move_limit)
          if target_piece = board.pieces["#{file}#{rank}"]
            piece_collision(moving_piece, target_piece, "#{file}#{rank}", spaces)
            break
          else
            moves_so_far += 1
            spaces, rank, file = add_space(spaces, rank, file, {:rank_change => :inc,
                                             :file_change => :dec})
          end
        end
      when :southeast
        rank -= 1
        file = incf(file)
        until invalid?(rank, file, moves_so_far, move_limit)
          if target_piece = board.pieces["#{file}#{rank}"]
            piece_collision(moving_piece, target_piece, "#{file}#{rank}", spaces)
            break
          else
            moves_so_far += 1
            spaces, rank, file = add_space(spaces, rank, file, {:rank_change => :dec,
                                             :file_change => :inc})
          end
        end
      when :southwest
        rank -= 1
        file = decf(file)
        until invalid?(rank, file, moves_so_far, move_limit)
          if target_piece = board.pieces["#{file}#{rank}"]
            piece_collision(moving_piece, target_piece, "#{file}#{rank}", spaces)
            break
          else
            moves_so_far += 1
            spaces, rank, file = add_space(spaces, rank, file, {:rank_change => :dec,
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

    def add_space(spaces, rank, file, changes)
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

      [spaces, rank, file]
    end

    def invalid?(rank, file, moves_so_far, move_limit)
      rank > 8 or rank < 1 or file > 'h' or file < 'a' or moves_so_far > move_limit
    end
  end
end
