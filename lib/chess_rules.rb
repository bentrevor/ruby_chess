class ChessRules
  class << self
    def valid_move?(move, board, current_color)
      starting_space = move.split.first
      ending_space = move.split.last
      space = board.get_space(starting_space)
      piece = space.piece

      return false if piece.nil?
      return false if piece.color != current_color
      return false unless moves_for(board, starting_space).include? ending_space

      true
    end

    def game_over?(board)
      false
    end

    def in_check?(board, color)
      king_space = find_king_space(board, color)
      other_color = [:white, :black].find { |c| c != color}

      all_moves_for(board, other_color).include?(king_space)
    end

    def find_king_space(board, color)
      board.pieces.find do |space, piece|
        piece.color == color and piece.abbrev == 'k'
      end[0]
    end

    def all_moves_for(board, color)
      spaces_with_pieces = board.pieces.select do |space, piece|
        piece.color == color
      end.keys

      moves = spaces_with_pieces.map do |space|
        moves_for(board, space)
      end.flatten.uniq
    end

    def moves_for(board, starting_space)
      moves = []
      piece = board.get_piece(starting_space)

      piece.directions.each do |direction|
        moves << remaining_spaces_for(board, direction, starting_space)
      end

      moves.flatten
    end

    def remaining_spaces_for(board, direction, current_space)
      moving_piece = board.get_piece(current_space)
      spaces = []
      file = current_space[0]
      rank = current_space[1].to_i
      moves_so_far = 0

      case direction
      when :north
        rank += 1
        until rank > 8 or moves_so_far >= moving_piece.limit
          if target_piece = board.get_piece("#{file}#{rank}")
            spaces = piece_collision(moving_piece, target_piece, "#{file}#{rank}", spaces)
            break
          else
            spaces << "#{file}#{rank}"
            moves_so_far += 1
            rank += 1
          end
        end
      when :south
        rank -= 1
        until rank < 1 or moves_so_far >= moving_piece.limit
          if target_piece = board.get_piece("#{file}#{rank}")
            spaces = piece_collision(moving_piece, target_piece, "#{file}#{rank}", spaces)
            break
          else
            spaces << "#{file}#{rank}"
            moves_so_far += 1
            rank -= 1
          end
        end
      when :east
        file = incf(file)
        until file > 'h' or moves_so_far >= moving_piece.limit
          if target_piece = board.get_piece("#{file}#{rank}")
            spaces = piece_collision(moving_piece, target_piece, "#{file}#{rank}", spaces)
            break
          else
            spaces << "#{file}#{rank}"
            moves_so_far += 1
            file = incf(file)
          end
        end
      when :west
        file = decf(file)
        until file < 'a' or moves_so_far >= moving_piece.limit
          if target_piece = board.get_piece("#{file}#{rank}")
            spaces = piece_collision(moving_piece, target_piece, "#{file}#{rank}", spaces)
            break
          else
            spaces << "#{file}#{rank}"
            moves_so_far += 1
            file = decf(file)
          end
        end
      when :northeast
        rank += 1
        file = incf(file)
        until file > 'h' or rank > 8 or moves_so_far >= moving_piece.limit
          if target_piece = board.get_piece("#{file}#{rank}")
            spaces = piece_collision(moving_piece, target_piece, "#{file}#{rank}", spaces)
            break
          else
            spaces << "#{file}#{rank}"
            moves_so_far += 1
            rank += 1
            file = incf(file)
          end
        end
      when :northwest
        rank += 1
        file = decf(file)
        until file < 'a' or rank > 8 or moves_so_far >= moving_piece.limit
          if target_piece = board.get_piece("#{file}#{rank}")
            spaces = piece_collision(moving_piece, target_piece, "#{file}#{rank}", spaces)
            break
          else
            spaces << "#{file}#{rank}"
            moves_so_far += 1
            rank += 1
            file = decf(file)
          end
        end
      when :southeast
        rank -= 1
        file = incf(file)
        until file > 'h' or rank < 1 or moves_so_far >= moving_piece.limit
          if target_piece = board.get_piece("#{file}#{rank}")
            spaces = piece_collision(moving_piece, target_piece, "#{file}#{rank}", spaces)
            break
          else
            spaces << "#{file}#{rank}"
            moves_so_far += 1
            rank -= 1
            file = incf(file)
          end
        end
      when :southwest
        rank -= 1
        file = decf(file)
        until file < 'a' or rank < 1 or moves_so_far >= moving_piece.limit
          if target_piece = board.get_piece("#{file}#{rank}")
            spaces = piece_collision(moving_piece, target_piece, "#{file}#{rank}", spaces)
            break
          else
            spaces << "#{file}#{rank}"
            moves_so_far += 1
            rank -= 1
            file = decf(file)
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
  end
end
