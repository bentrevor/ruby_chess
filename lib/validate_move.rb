class ValidateMove
  attr_accessor :rules

  def self.call(move, rules)
    new(rules).call(move)
  end

  def initialize(rules)
    self.rules = rules
  end

  def call(move)
    raise Rules::InvalidMoveError.new("Invalid input:\nEnter a move like 'a2 - a4'.") if invalid_move_format?(move)

    starting_space = move.starting_space
    piece = rules.board.get_space(starting_space).piece

    raise Rules::InvalidMoveError.new("Invalid move:\nThere is no piece at #{starting_space}.") if piece.nil?
    raise Rules::InvalidMoveError.new("Invalid move:\nWrong color.") if wrong_color?(piece)

    moves_for_space = rules.all_moves_for_space(starting_space)
    target_spaces = moves_for_space.map(&:target_space)

    raise Rules::InvalidMoveError.new("Invalid move:\nYou can't move there.") unless target_spaces.include?(move.target_space)
    raise Rules::InvalidMoveError.new("Invalid move:\nYou're moving into check or something.") if rules.moving_into_check?(move)
    raise Rules::InvalidMoveError.new("Invalid move:\nSpecify the promotion.") if rules.unspecified_pawn_promotion?(move)
    raise Rules::InvalidMoveError.new("Invalid move:\nYou can't promote a pawn there.") if invalid_pawn_promotion_target?(move)

    true
  end

  private

  def invalid_move_format?(move)
    !Utils.correctly_formatted_move?(move)
  end

  def wrong_color?(piece)
    piece.color != rules.player.color
  end

  def invalid_pawn_promotion_target?(move)
    if move.type == :promotion
      target_file = move.target_space[1]
      ! (target_file.to_s =~ /[18]/)
    end
  end
end
