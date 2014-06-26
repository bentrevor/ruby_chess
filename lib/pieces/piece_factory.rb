class PieceFactory
  def self.create(color, type)
    case type
    when :rook
      Rook.new(color)
    when :bishop
      Bishop.new(color)
    when :pawn
      Pawn.new(color)
    when :king
      King.new(color)
    when :queen
      Queen.new(color)
    when :knight
      Knight.new(color)
    end
  end
end
