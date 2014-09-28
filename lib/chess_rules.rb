class ChessRules
  class << self
    def valid_move?(move, board, current_player)
      current_color = current_player.color
      starting_space = move.split.first
      target_space = move.split.last
      piece = board.get_space(starting_space).piece

      return false if piece.nil?
      return false if piece.color != current_color

      moves = FindMoves.call(board, starting_space)
      valid_moves = find_valid(moves, board, starting_space, current_player)
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

    def wrong_color?(space, color)
      if color == :white
        space != 'e1'
      elsif color == :black
        space != 'e8'
      end
    end

    def castle_moves(board, starting_space, current_player)
      color = current_player.color

      if board.pieces[starting_space].class != King or wrong_color?(starting_space, current_player.color)
        []
      else
        castle_spaces_for color, board
      end
    end

    def all_empty_spaces?(board, spaces)
      spaces.each do |space|
        return false if board.pieces[space]
      end
      true
    end

    def castle_spaces_for(color, board)
      spaces = []

      if color == :white
        if all_empty_spaces?(board, ['b1', 'c1', 'd1'])
          spaces << 'c1'
        end
        if board.pieces['f1'].nil? and board.pieces['g1'].nil?
          spaces << 'g1'
        end
        binding.pry
      else
        if board.pieces['b8'].nil? and board.pieces['c8'].nil? and board.pieces['d8'].nil?
          spaces << 'c8'
        end
        if board.pieces['f8'].nil? and board.pieces['g8'].nil?
          spaces << 'g8'
        end
      end

      spaces
    end

    def find_valid(target_spaces, board, starting_space, current_player)
      current_color = current_player.color
      valid_moves = []
      piece = board.pieces[starting_space]

      target_spaces.each do |new_space|
        board.try_move("#{starting_space} - #{new_space}") do
          if !in_check?(board, current_color)
            valid_moves << new_space
          end
        end
      end

      valid_moves + castle_moves(board, starting_space, current_player)
    end
  end
end
