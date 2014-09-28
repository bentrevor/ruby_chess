require 'readline'

class ConsoleReader
  def self.get_move
    input = Readline.readline("\n--> ", true)
    input
  end
end
