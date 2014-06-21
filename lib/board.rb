class ChessBoard
  attr_accessor :spaces

  def initialize
    initialize_layout
  end

  private

  def initialize_layout
    self.spaces = Array.new 64
    self.spaces[0] = Piece.new :rook,   :black
    self.spaces[1] = Piece.new :knight, :black
    self.spaces[2] = Piece.new :bishop, :black
    self.spaces[3] = Piece.new :queen,  :black
    self.spaces[4] = Piece.new :king,   :black
    self.spaces[5] = Piece.new :bishop, :black
    self.spaces[6] = Piece.new :knight, :black
    self.spaces[7] = Piece.new :rook,   :black
    (8..15).each { |i| self.spaces[i] = Piece.new :pawn, :black }

    (48..55).each { |i| self.spaces[i] = Piece.new :pawn, :white }
    self.spaces[56] = Piece.new :rook,   :white
    self.spaces[57] = Piece.new :knight, :white
    self.spaces[58] = Piece.new :bishop, :white
    self.spaces[59] = Piece.new :queen,  :white
    self.spaces[60] = Piece.new :king,   :white
    self.spaces[61] = Piece.new :bishop, :white
    self.spaces[62] = Piece.new :knight, :white
    self.spaces[63] = Piece.new :rook,   :white
  end
end

class EchoBoard
  attr_accessor :spaces

  def initialize
    self.spaces = ''
  end

  def place_move(move)
    spaces << move
  end
end
