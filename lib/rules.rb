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

    starting_space = move.starting_space
    piece = board.get_space(starting_space).piece

    raise InvalidMoveError.new("Invalid move:\nThere is no piece at #{starting_space}.") if piece.nil?
    raise InvalidMoveError.new("Invalid move:\nWrong color.") if piece.color != player.color

    moves_for_space = all_moves_for_space(starting_space)
    target_spaces = moves_for_space.map(&:target_space)
    raise InvalidMoveError.new("Invalid move:\nYou can't move there.") unless target_spaces.include?(move.target_space)
    raise InvalidMoveError.new("Invalid move:\nYou're moving into check or something.") unless legal_move?(move)
    raise InvalidMoveError.new("Invalid move:\nSpecify the promotion.") if unspecified_pawn_promotion?(move)

    true
  end

  def game_over?
    all_moves_for_player.empty?
  end

  def winner
    other_player if game_over?
  end

  def in_check?
    return unless king_space = find_king_space(player.color)

    all_target_spaces_for_color(other_player.color).include?(king_space)
  end

  def all_moves_for_space(space)
    Moves.for(space, self)
  end

  private

  def all_moves_for_player
    all_moves_for_color(player.color).select { |move| legal_move?(move) }
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

    moves = spaces_with_pieces.map do |space|
      Moves::ForLinearPiece.for(board, space) + Moves::ForKnight.for(board, space) + Moves::ForPawn.for(board, space)
    end

    moves.flatten.uniq
  end

  def all_target_spaces_for_color(color)
    moves = all_moves_for_color(color)

    moves.map do |move|
      move.target_space
    end
  end

  def unspecified_pawn_promotion?(move)
    board.pieces[move.starting_space].is_a?(Pawn) && move.target_space[1] =~ /[18]/ && move.text[3] == '-'
  end
end
