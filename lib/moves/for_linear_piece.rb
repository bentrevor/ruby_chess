module Moves
  class ForLinearPiece
    class << self
      def for(board, starting_space)
        return [] if non_linear_piece?(board.pieces[starting_space])

        piece = board.pieces[starting_space]

        spaces = piece.directions.map do |direction|
          remaining_spaces_for(board, direction, starting_space)
        end

        target_spaces = spaces.flatten.select { |move| Utils.on_board?(move) }

        target_spaces.map { |target_space| "#{starting_space} - #{target_space}" }
      end

      private

      def remaining_spaces_for(board, direction, starting_space, spaces=[])
        moving_piece = board.pieces[starting_space]
        starting_rank = starting_space[1].to_i

        return spaces if spaces.length >= moving_piece.limit(starting_rank)

        current_space = spaces.last || starting_space
        next_space = board.move_in_direction(current_space, direction)

        return spaces if Utils.off_board?(next_space)

        piece_in_next_space = board.pieces[next_space]

        if piece_in_next_space.nil?
          remaining_spaces_for(board, direction, starting_space, spaces.push(next_space))
        elsif piece_in_next_space.color != moving_piece.color
          spaces.push(next_space)
        else
          spaces
        end
      end

      def non_linear_piece?(piece)
        [Pawn, Knight].include? piece.class
      end
    end
  end
end
