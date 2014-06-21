class Writer
  def self.show(message)
    $stdout.puts message
  end

  def self.show_board(board)
    show board.spaces
  end
end
