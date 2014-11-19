require 'readline'

class ConsoleReader
  def self.get_move(board, rules, player)
    input = Readline.readline("\n--> ", true)
    Move.new(input)
  end
end
