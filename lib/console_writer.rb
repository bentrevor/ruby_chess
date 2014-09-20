class ConsoleWriter
  class << self
    def show(message)
      $stdout.puts message
    end

    def show_board(board)
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

    def unicode_for(piece)
      {
        "wk" => "\u2654",
        "wq" => "\u2655",
        "wr" => "\u2656",
        "wb" => "\u2657",
        "wn" => "\u2658",
        "wp" => "\u2659",

        "bk" => "\u265A",
        "bq" => "\u265B",
        "br" => "\u265C",
        "bb" => "\u265D",
        "bn" => "\u265E",
        "bp" => "\u265F",
      }["#{piece.color[0]}#{piece.abbrev}"].encode("utf-8") if piece
    end
  end
end
