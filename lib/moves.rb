Dir[File.expand_path("lib/pieces/*.rb")].each { |f| require f }
Dir[File.expand_path("lib/moves/*.rb")].each { |f| require f }

require './lib/pieces/king'

module Moves
  def self.for(board, space, player, rules)
    Linear.for(board, space) + Knight.for(board, space) + Castling.for(board, player, rules)
  end
end
