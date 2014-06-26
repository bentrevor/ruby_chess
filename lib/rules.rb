class ChessRules
  def self.valid_move?(move, board, current_color)
    starting_index = move.split.first
    ending_index = move.split.last
    original_space = board.get_space(starting_index)
    original_piece = original_space.piece

    return false if original_piece.nil?
    return false if original_piece.color != current_color
    return false unless original_piece.available_moves(board, starting_index).include? ending_index

    true
  end
end
