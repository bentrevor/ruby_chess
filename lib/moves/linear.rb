module Moves
  class Linear
    include ChessBoardHelpers

    class << self
      def for(board, starting_space)
        return [] if board.pieces[starting_space].is_a? Piece::Knight

        moves = []
        piece = board.pieces[starting_space]

        piece.directions.each do |direction|
          moves << remaining_spaces_for(board, direction, starting_space)
        end

        moves.flatten
      end

      private

      def remaining_spaces_for(board, direction, starting_space, spaces=[])
        moving_piece = board.pieces[starting_space]
        starting_rank = starting_space[1].to_i

        current_space = spaces.last || starting_space
        file = current_space[0]
        rank = current_space[1].to_i
        inc_file = ChessBoardHelpers.inc_file(file)
        dec_file = ChessBoardHelpers.dec_file(file)

        return spaces if spaces.length >= moving_piece.limit(starting_rank)

        next_space = {
          :north     => "#{file}#{rank + 1}",
          :east      => "#{inc_file}#{rank}",
          :south     => "#{file}#{rank - 1}",
          :west      => "#{dec_file}#{rank}",
          :northeast => "#{inc_file}#{rank + 1}",
          :southeast => "#{inc_file}#{rank - 1}",
          :southwest => "#{dec_file}#{rank - 1}",
          :northwest => "#{dec_file}#{rank + 1}"
        }[direction]

        piece_in_next_space = board.pieces[next_space]

        if piece_in_next_space.nil?
          remaining_spaces_for(board, direction, starting_space, spaces.push(next_space))
        elsif piece_in_next_space.color != moving_piece.color
          spaces.push(next_space)
        else
          spaces
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
end
