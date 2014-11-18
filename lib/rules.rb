class Rules

  class InvalidMoveError < StandardError
    attr_accessor :message

    def initialize(msg)
      self.message = msg
    end
  end

  attr_accessor :board, :player, :other_player

  def initialize(board, player, other_player)
    self.board  = board
    self.player = player
    self.other_player = other_player
  end

  def valid_move?(move)
    raise InvalidMoveError.new("Invalid input:\nEnter a move like 'a2 - a4'.") unless Utils.correctly_formatted_move?(move)

    starting_space = move.split.first
    piece = board.get_space(starting_space).piece

    raise InvalidMoveError.new("Invalid move:\nThere is no piece at #{starting_space}.") if piece.nil?
    raise InvalidMoveError.new("Invalid move:\nWrong color.") if piece.color != player.color

    moves_for_space = all_moves_for_space(starting_space)
    raise InvalidMoveError.new("Invalid move:\nYou can't move there.") unless moves_for_space.include?(move)
    raise InvalidMoveError.new("Invalid move:\nYou can't move there.") unless legal_move?(move)

    true
  end

  def game_over?
    false
  end

  def all_moves_for_player
    all_moves_for_color(player.color)
  end

  def in_check?
    return unless king_space = find_king_space(player.color)

    all_target_spaces_for_color(other_player.color).include?(king_space)
  end

  def all_moves_for_space(space)
    Moves.for(space, self)
  end

  def legal_move?(move)
    valid_move = true

    board.try_move(move) do
      valid_move = false if in_check?
    end

    valid_move
  end

  def find_king_space(color)
    board.pieces.find do |space, piece|
      return space if piece.color == color && piece.class == King
    end
  end

  def all_moves_for_color(color)
    spaces_with_pieces = board.pieces.select do |space, piece|
      piece.color == color
    end.keys

    target_spaces = spaces_with_pieces.map do |space|
      Moves::ForLinearPiece.for(board, space) + Moves::ForKnight.for(board, space) + Moves::ForPawn.for(board, space)
    end

    target_spaces.flatten.uniq
  end

  def all_target_spaces_for_color(color)
    moves = all_moves_for_color(color)

    moves.map do |move|
      move[-2..-1]
    end
  end
end
