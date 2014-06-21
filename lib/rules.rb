class EchoRules
  def self.game_over?(board)
    board.spaces.length > 5
  end

  def self.winner
    :nobody
  end

  def self.valid_move?(move)
    true
  end
end
