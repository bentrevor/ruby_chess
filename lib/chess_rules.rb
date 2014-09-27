class ChessRules
  class << self
    def valid_move?(move, board, current_color)
      starting_space = move.split.first
      target_space = move.split.last
      piece = board.get_space(starting_space).piece

      return false if piece.nil?
      return false if piece.color != current_color

      moves = FindMoves.call(board, starting_space)
      valid_moves = find_valid(moves, board, starting_space, current_color)
      return false unless valid_moves.include? target_space

      true
    end

    def game_over?(board)
      false
    end

    def in_check?(board, color)
      return unless king_space = find_king_space(board, color)
      other_color = [:white, :black].find { |c| c != color}

      all_moves_for(board, other_color).include?(king_space)
    end

    def find_king_space(board, color)
      board.pieces.find do |space, piece|
        return space if piece.color == color and piece.class == King
      end
    end

    def all_moves_for(board, color)
      spaces_with_pieces = board.pieces.select do |space, piece|
        piece.color == color
      end.keys

      moves = spaces_with_pieces.map do |space|
        FindMoves.call(board, space)
      end.flatten.uniq
    end

    def find_valid(target_spaces, board, starting_space, current_color)
      valid_moves = []
      piece = board.pieces[starting_space]
      target_spaces.each do |new_space|
        board.try_move("#{starting_space} - #{new_space}") do
          if !in_check?(board, current_color)
            valid_moves << new_space
          end
        end
      end
      valid_moves
    end
  end
end
