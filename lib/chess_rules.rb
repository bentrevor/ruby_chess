class ChessRules
  class << self
    def valid_move?(move, board, current_player)
      current_color = current_player.color
      starting_space = move.split.first
      target_space = move.split.last
      piece = board.get_space(starting_space).piece

      raise InvalidMoveError.new("Invalid move:\nThere is no piece at #{starting_space}.") if piece.nil?
      raise InvalidMoveError.new("Invalid move:\nWrong color.") if piece.color != current_color

      moves = FindMoves.call(board, starting_space)
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

    def wrong_color?(space, color)
      if color == :white
        space != 'e1'
      elsif color == :black
        space != 'e8'
      end
    end

    def cant_castle?(board, starting_space, current_player)
      board.pieces[starting_space].class != King or
        wrong_color?(starting_space, current_player.color) or
        in_check?(board, current_player.color)
    end

    def all_empty_spaces?(board, spaces)
      spaces.each do |space|
        return false if board.pieces[space]
      end
      true
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

    def not_castling_through_check?(board, player, target_file)
      color = player.color

      starting_space = (color == :white) ? 'e1' : 'e8'
      target_space = "#{target_file}#{home_rank(color)}"

      board.try_move("#{starting_space} - #{target_space}") do
        return false if in_check?(board, color)
      end
      true
    end

    def castle_spaces_for(player, board)
      spaces = []

      spaces << "c#{home_rank(player.color)}" if can_castle_left?(board, player)
      spaces << "g#{home_rank(player.color)}" if can_castle_left?(board, player)

      spaces
    end

    def home_rank(color)
      (color == :white) ? 1 : 8
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

      valid_moves + castle_moves(board, starting_space, current_player)
    end

    def castle_moves(board, starting_space, current_player)
      if cant_castle?(board, starting_space, current_player)
        []
      else
        castle_spaces_for current_player, board
      end
    end
  end

  class InvalidMoveError < StandardError
    attr_accessor :message

    def initialize(msg)
      self.message = msg
    end
  end
end
