class Move
  attr_accessor :starting_space, :target_space, :text, :type

  def initialize(move)
    self.text = move
    self.starting_space = move[0..1]
    self.target_space = move[-2..-1]
    self.type = case move[3]
                when '-'
                  :normal
                when 'c'
                  :castle
                when 'k', 'b', 'r', 'q'
                  :promotion
                end
  end

  def ==(other_move)
    self.text == other_move.text
  end
end
