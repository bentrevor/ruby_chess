module Moves
  def self.for(space, rules)
    board = rules.board
    player = rules.player

    if board.pieces[space]
      ForLinearPiece.for(board, space) + ForKnight.for(board, space) + ForPawn.for(board, space) + ForCastling.for(rules)
    else
      []
    end
  end
end
