class CastleMoves
  class << self
    def for(board, starting_space, current_player, rules)
      @rules = rules
      if cant_castle?(board, starting_space, current_player)
        []
      else
        castle_spaces_for current_player, board
      end
    end

    private

    def cant_castle?(board, starting_space, current_player)
      board.pieces[starting_space].class != King or
        wrong_color?(starting_space, current_player.color) or
        @rules.in_check?(board, current_player.color)
    end

    def wrong_color?(space, color)
      if color == :white
        space != 'e1'
      elsif color == :black
        space != 'e8'
      end
    end

    def castle_spaces_for(player, board)
      spaces = []

      spaces << "c#{home_rank(player.color)}" if can_castle_left?(board, player)
      spaces << "g#{home_rank(player.color)}" if can_castle_left?(board, player)

      spaces
    end

    def can_castle_left?(board, player)
      spaces = if player.color == :white
                 ['b1', 'c1', 'd1']
               else
                 ['b8', 'c8', 'd8']
               end

      player.can_castle_left and
        all_empty_spaces?(board, spaces) and
        not_castling_through_check?(board, player, 'd')
    end

    def can_castle_right?(board, player)
      spaces = if player.color == :white
                 ['f1', 'g1']
               else
                 ['f8', 'g8']
               end

      player.can_castle_right and
        all_empty_spaces?(board, spaces) and
        not_castling_through_check?(board, player, 'f')
    end

    def all_empty_spaces?(board, spaces)
      spaces.each do |space|
        return false if board.pieces[space]
      end
      true
    end

    def not_castling_through_check?(board, player, target_file)
      color = player.color

      starting_space = (color == :white) ? 'e1' : 'e8'
      target_space = "#{target_file}#{home_rank(color)}"

      board.try_move("#{starting_space} - #{target_space}") do
        return false if @rules.in_check?(board, color)
      end
      true
    end

    def home_rank(color)
      (color == :white) ? 1 : 8
    end
  end
end
