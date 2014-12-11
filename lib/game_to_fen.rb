class GameToFen
  class << self
    def call(game)
      board = game.board
      rows = []
      current_row = []

      board.spaces.each_with_index do |space, index|
        current_row << space
        if index % 8 == 7
          rows << current_row
          current_row = []
        end
      end

      abbrev_rows = rows.reverse.map do |row|
        row.map do |space|
          piece = space.piece
          abbrev_for(piece)
        end
      end

      all_spaces = abbrev_rows.map(&:join).join('/')

      squish_empty_spaces(all_spaces)
    end

    def squish_empty_spaces(spaces)
      i = spaces.index(/\d\d/)
      if i
        sum = (spaces[i].to_i + spaces[i + 1].to_i).to_s
        squish_empty_spaces(spaces[0..(i - 1)] + sum + spaces[(i + 2)..-1])
      else
        spaces
      end
    end

    def abbrev_for(piece)
      if piece
        if piece.color == :white
          piece.abbrev.upcase
        else
          piece.abbrev
        end
      else
        '1'
      end
    end
  end
end
