module Moves
  class ForPawn
    include ChessBoardHelpers

    def self.for(board, space)
      return [] unless board.pieces[space].is_a? Pawn

      Moves::ForLinearPiece.for(board, space) + capture_spaces(board, space)
    end

    private

    def self.capture_spaces(board, space)
      piece = board.pieces[space]

      target_spaces(board, space).select do |target_space|
        target_piece = board.pieces[target_space]

        target_piece && target_piece.color != piece.color
      end
    end

    def self.target_spaces(board, space)
      file = space[0]
      rank = space[1].to_i

      next_rank = if board.pieces[space].color == :white
                    rank + 1
                  else
                    rank - 1
                  end

      ["#{ChessBoardHelpers.inc_file(file)}#{next_rank}",
       "#{ChessBoardHelpers.dec_file(file)}#{next_rank}"]
    end
  end
end
