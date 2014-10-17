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

      moves = LinearMoves.call(board, starting_space)
      valid_moves = find_valid(moves, board, starting_space, current_player)
      raise InvalidMoveError.new("Invalid move:\nYou can't move there.") unless valid_moves.include? target_space

      true
    end

    def game_over?(board)
      false
    end

    def winner(board)
    end

    def in_check?(board, color)
      return unless king_space = find_king_space(board, color)
      other_color = [:white, :black].find { |c| c != color}

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
        LinearMoves.call(board, space)
      end.flatten.uniq
    end

    def find_valid(target_spaces, board, starting_space, current_player)
      valid_moves = []

      target_spaces.each do |new_space|
        board.try_move("#{starting_space} - #{new_space}") do
          if !in_check?(board, current_player.color)
            valid_moves << new_space
          end
        end
      end

      valid_moves + CastlingMoves.for(board, starting_space, current_player, self)
    end
  end

  class InvalidMoveError < StandardError
    attr_accessor :message

    def initialize(msg)
      self.message = msg
    end
  end
end
