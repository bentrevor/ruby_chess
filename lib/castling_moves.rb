class CastlingMoves
  class << self
    def for(board, current_player, rules)
      @rules = rules
      @starting_space = (current_player.color == :white) ? 'e1' : 'e8'
      if can_castle?(board, current_player)
        castle_spaces_for(board, current_player)
      else
        []
      end
    end

    private

    def can_castle?(board, current_player)
      board.pieces[@starting_space].is_a?(King) &&
        !@rules.in_check?(board, current_player.color)
    end

    def castle_spaces_for(board, player)
      spaces = []

      spaces << "c#{home_rank(player.color)}" if can_castle_left?(board, player)
      spaces << "g#{home_rank(player.color)}" if can_castle_right?(board, player)

      spaces
    end

    def can_castle_left?(board, player)
      spaces = if player.color == :white
                 ['b1', 'c1', 'd1']
               else
                 ['b8', 'c8', 'd8']
               end

      player.can_castle_left &&
        safe_castle_spaces?(board, player, spaces)
    end

    def can_castle_right?(board, player)
      spaces = if player.color == :white
                 ['f1', 'g1']
               else
                 ['f8', 'g8']
               end

      player.can_castle_right &&
        safe_castle_spaces?(board, player, spaces)
    end

    def safe_castle_spaces?(board, player, spaces)
      all_empty_spaces?(board, spaces) && !castling_through_check?(board, player, spaces)
    end

    def castling_through_check?(board, player, spaces)
      castling_through_check = false
      color = player.color
      rank = home_rank(color)

      target_spaces = spaces.reject{ |s| s.include?('b') }

      target_spaces.each do |target_space|
        board.try_move("#{@starting_space} - #{target_space}") do
          castling_through_check = true if @rules.in_check?(board, color)
        end
      end

      castling_through_check
    end

    def all_empty_spaces?(board, spaces)
      spaces.each do |space|
        return false if board.pieces[space]
      end
      true
    end

    def home_rank(color)
      (color == :white) ? 1 : 8
    end
  end
end
