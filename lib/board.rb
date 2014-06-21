class EchoBoard
  attr_accessor :spaces

  def initialize
    self.spaces = ''
  end

  def place_move(move)
    spaces << move
  end
end

class Board
  def spaces
    Array.new 64
  end
end
