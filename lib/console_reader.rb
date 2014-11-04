require 'readline'

class ConsoleReader
  def self.get_move(board, rules)
    input = Readline.readline("\n--> ", true)
    input
  end
end
