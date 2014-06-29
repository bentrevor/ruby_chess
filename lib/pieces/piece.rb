class Piece
  attr_accessor :abbrev, :color, :directions, :limit

  DIAGONAL_DIRECTIONS = [:northeast, :northwest, :southeast, :southwest]
  NON_DIAGONAL_DIRECTIONS = [:north, :east, :south, :west]
  ALL_DIRECTIONS = DIAGONAL_DIRECTIONS + NON_DIAGONAL_DIRECTIONS

  def initialize(color)
    self.color = color
  end

  def available_moves(board, current_space)
    moves = []

    directions.each do |direction|
      moves << remaining_spaces_for(direction, current_space)
    end

    moves.flatten
  end

  private

  def remaining_spaces_for(direction, current_space)
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
        file = inc_file(file)
        spaces << "#{file}#{rank}"
      end
    when :west
      until file == 'a'
        file = dec_file(file)
        spaces << "#{file}#{rank}"
      end
    when :northeast
      until file == 'h' or rank == 8
        rank += 1
        file = inc_file(file)
        spaces << "#{file}#{rank}"
      end
    when :northwest
      until file == 'a' or rank == 8
        rank += 1
        file = dec_file(file)
        spaces << "#{file}#{rank}"
      end
    when :southeast
      until file == 'h' or rank == 1
        rank -= 1
        file = inc_file(file)
        spaces << "#{file}#{rank}"
      end
    when :southwest
      until file == 'a' or rank == 1
        rank -= 1
        file = dec_file(file)
        spaces << "#{file}#{rank}"
      end
    end

    spaces
  end

  def inc_file(file)
    (file.ord + 1).chr
  end

  def dec_file(file)
    (file.ord - 1).chr
  end
end
