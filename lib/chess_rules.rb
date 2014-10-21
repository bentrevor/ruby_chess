class ChessRules
  class << self
    def valid_move?(move, board, current_player)
      validate_move_format(move)

      current_color = current_player.color
      starting_space = move.split.first
      target_space = move.split.last
      piece = board.get_space(starting_space).piece

      raise InvalidMoveError.new("Invalid move:\nThere is no piece at #{starting_space}.") if piece.nil?
      raise InvalidMoveError.new("Invalid move:\nWrong color.") if piece.color != current_color

      moves_for_space = all_moves(board, starting_space, current_player)
      raise InvalidMoveError.new("Invalid move:\nYou can't move there.") unless moves_for_space.include?(target_space)
      raise InvalidMoveError.new("Invalid move:\nYou can't move there.") unless legal_move?(target_space, board, starting_space)

      true
    end

    def all_moves(board, starting_space, current_player)
      LinearMoves.call(board, starting_space) + KnightMoves.by_bob_seger(board, starting_space) + CastlingMoves.for(board, current_player, self)
    end

    def game_over?(board)
      false
    end

    def winner(board)
    end

    def in_check?(board, color)
      return unless king_space = find_king_space(board, color)
      other_color = (color == :white) ? :black : :white

      all_moves_for(board, other_color).include?(king_space)
    end

    private

    def validate_move_format(move)
      if move.length != 7 or
          move[3] != '-' or
          !(1..8).include?(move[1].to_i) or
          !(1..8).include?(move[-1].to_i)
        raise InvalidMoveError.new("Invalid input:\nEnter a move like 'a2 - a4'.")
      end
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
        LinearMoves.call(board, space) + KnightMoves.by_bob_seger(board, space)
      end.flatten.uniq
    end

    def legal_move?(target_space, board, starting_space)
      valid_move = true
      color = board.pieces[starting_space].color

      board.try_move("#{starting_space} - #{target_space}") do
        if in_check?(board, color)
          valid_move = false
        end
      end

      valid_move
    end
  end

  class InvalidMoveError < StandardError
    attr_accessor :message

    def initialize(msg)
      self.message = msg
    end
  end
end
