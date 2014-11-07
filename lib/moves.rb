module Moves
  def self.for(board, space, player, rules)
    if board.pieces[space]
      ForLinearPiece.for(board, space) + ForKnight.for(board, space) + ForPawn.for(board, space) + ForCastling.for(board, player, rules)
    else
      []
    end
  end
end
