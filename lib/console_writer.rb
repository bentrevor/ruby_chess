class ConsoleWriter
  class << self
    def show(message)
      $stdout.puts message
    end

    def show_board(board)
      Kernel.system "clear"
      show(printable(board.spaces))
    end

    def printable(spaces)
      flat_pieces = spaces.map(&:piece).map do |piece|
        unicode_for(piece)
      end

      rows = flat_pieces.each_slice(8).to_a.map {|row| row.join ' '}.reverse

      i = 0
      rows = rows.map do |row|
        i += 1
        "#{9 - i} #{row}"
      end

      rows.unshift "   a b c d e f g h "
    end

    private

    def unicode_for(piece)
      if piece
        {
          "white k" => "\u2654",
          "white q" => "\u2655",
          "white r" => "\u2656",
          "white b" => "\u2657",
          "white n" => "\u2658",
          "white p" => "\u2659",

          "black k" => "\u265A",
          "black q" => "\u265B",
          "black r" => "\u265C",
          "black b" => "\u265D",
          "black n" => "\u265E",
          "black p" => "\u265F",
        }["#{piece.color} #{piece.abbrev}"].encode("utf-8")
      else
        " "
      end
    end
  end
end
