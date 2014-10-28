module Moves
  def self.for(board, space, player, rules)
    ForLinearPiece.for(board, space) + ForKnight.for(board, space) + ForCastling.for(board, player, rules)
  end
end
