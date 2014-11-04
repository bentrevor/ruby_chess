class Rules
  class << self
    def valid_move?(move, board, current_player)
      validate_move_format(move)

      current_color = current_player.color
      starting_space = move.split.first
      target_space = move.split.last
      piece = board.get_space(starting_space).piece

      raise InvalidMoveError.new("Invalid move:\nThere is no piece at #{starting_space}.") if piece.nil?
      raise InvalidMoveError.new("Invalid move:\nWrong color.") if piece.color != current_color

      moves_for_space = Moves.for(board, starting_space, current_player, self)
      raise InvalidMoveError.new("Invalid move:\nYou can't move there.") unless moves_for_space.include?(target_space)
      raise InvalidMoveError.new("Invalid move:\nYou can't move there.") unless legal_move?(target_space, board, starting_space)

      true
    end

    def game_over?(board)
      false
    end

    def all_moves_for_space(space, board)
      if board.pieces[space]
        (Moves::ForLinearPiece.for(board, space) + Moves::ForKnight.for(board, space)).select do |space|
          Utils.on_board?(space)
        end
      else
        []
      end
    end

    def all_moves_for_color(color, board)
      spaces_with_pieces = board.pieces.select do |space, piece|
        piece.color == color
      end.keys

      moves = spaces_with_pieces.map do |space|
        Moves::ForLinearPiece.for(board, space) + Moves::ForKnight.for(board, space)
      end.flatten.uniq
    end

    def winner(board)
    end

    def in_check?(board, color)
      return unless king_space = find_king_space(board, color)
      other_color = (color == :white) ? :black : :white

      all_moves_for_color(other_color, board).include?(king_space)
    end

    private

    def validate_move_format(move)
      if move.length != 7 ||
          move[3] != '-'  ||
          Utils.off_board?(move[0..1]) ||
          Utils.off_board?(move[-2..-1])
        raise InvalidMoveError.new("Invalid input:\nEnter a move like 'a2 - a4'.")
      end
    end

    def find_king_space(board, color)
      board.pieces.find do |space, piece|
        return space if piece.color == color && piece.class == King
      end
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
