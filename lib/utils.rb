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
      move.text.length == 7                                &&
        [:normal, :castle, :promotion].include?(move.type) &&
        on_board?(move.starting_space)                     &&
        on_board?(move.target_space)
    end

    def spaces_to_moves(target_spaces, starting_space)
      target_spaces.map { |target_space| Move.new("#{starting_space} - #{target_space}") }
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
