class ChessRules
  def self.valid_move?(move, board, current_color)
    starting_space = move.split.first
    ending_space = move.split.last
    space = board.get_space(starting_space)
    piece = space.piece

    return false if piece.nil?
    return false if piece.color != current_color
    return false unless moves_for(piece, board, starting_space).include? ending_space

    true
  end

  def self.game_over?(board)
    false
  end

  private

  def self.moves_for(piece, board, starting_index)
    moves = []

    piece.directions.each do |direction|
      moves << remaining_spaces_for(direction, starting_index)
    end

    moves.flatten
  end

  def self.remaining_spaces_for(direction, current_space)
    spaces = []
    file = current_space[0]
    rank = current_space[1].to_i
    case direction
    when :north
      until rank == 8
        rank += 1
        spaces << "#{file}#{rank}"
      end
    when :south
      until rank == 1
        rank -= 1
        spaces << "#{file}#{rank}"
      end
    when :east
      until file == 'h'
        file = incf(file)
        spaces << "#{file}#{rank}"
      end
    when :west
      until file == 'a'
        file = decf(file)
        spaces << "#{file}#{rank}"
      end
    when :northeast
      until file == 'h' or rank == 8
        rank += 1
        file = incf(file)
        spaces << "#{file}#{rank}"
      end
    when :northwest
      until file == 'a' or rank == 8
        rank += 1
        file = decf(file)
        spaces << "#{file}#{rank}"
      end
    when :southeast
      until file == 'h' or rank == 1
        rank -= 1
        file = incf(file)
        spaces << "#{file}#{rank}"
      end
    when :southwest
      until file == 'a' or rank == 1
        rank -= 1
        file = decf(file)
        spaces << "#{file}#{rank}"
      end
    end

    spaces
  end

  def self.incf(file)
    (file.ord + 1).chr
  end

  def self.decf(file)
    (file.ord - 1).chr
  end
end
