module Moves
  class ForPawn
    def self.for(board, space)
      return [] unless board.pieces[space].is_a? Pawn

      new(board, space).moves
    end

    def initialize(board, space)
      self.board = board
      self.space = space
      self.pawn  = board.pieces[space]
    end

    def moves
      linear_pawn_moves + capture_spaces
    end

    private

    attr_accessor :board, :space, :pawn

    def linear_pawn_moves
      direction = pawn.directions.first
      first_move = "#{space} - #{board.move_in_direction(space, direction)}"

      return [] if board.pieces[first_move]

      moves = [first_move]

      if pawn.on_home_rank?(space[1].to_i)
        second_move = "#{space} - #{board.move_in_direction(first_move, direction)}"
        moves << second_move unless board.pieces[second_move]
      end

      moves
    end

    def capture_spaces
      target_spaces.select do |target_space|
        target_piece = board.pieces[target_space]

        target_piece && target_piece.color != pawn.color
      end
    end

    def target_spaces
      file = space[0]
      rank = space[1].to_i

      next_rank = if pawn.color == :white
                    rank + 1
                  else
                    rank - 1
                  end

      ["#{Utils.inc_file(file)}#{next_rank}",
       "#{Utils.dec_file(file)}#{next_rank}"]
    end
  end
end
