module Utils
  class << self
    def inc_file(file)
      file.succ
    end

    def dec_file(file)
      (file.ord - 1).chr
    end

    def on_board?(space)
      ! off_board?(space)
    end

    def off_board?(space)
      bad_file(space) || bad_rank(space)
    end

    def correctly_formatted_move?(move)
      move.length == 7 &&
        move[3] == '-' &&
        on_board?(move.split.first) &&
        on_board?(move.split.last)
    end

    def spaces_to_moves(target_spaces, starting_space)
      target_spaces.map { |target_space| "#{starting_space} - #{target_space}" }
    end

    private

    def bad_file(space)
      ! ('a'..'h').include?(space[0])
    end

    def bad_rank(space)
      ! (space.length == 2 && (1..8).include?(space[1].to_i))
    end
  end
end
