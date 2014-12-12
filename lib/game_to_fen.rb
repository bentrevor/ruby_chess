class GameToFen
  class FenStruct < Struct.new(:rows_of_pieces, :active_color, :castling_availability, :en_passant_target_space, :halfmove_clock, :fullmove_number)
    def initialize(opts)
      self.rows_of_pieces          = opts[:rows_of_pieces].join('/')
      self.active_color            = opts[:active_color]
      self.castling_availability   = opts[:castling_availability]
      self.en_passant_target_space = opts[:en_passant_target_space]
      self.halfmove_clock          = opts[:halfmove_clock]
      self.fullmove_number         = opts[:fullmove_number]
    end
  end

  class << self
    def call(game)
      build_fen_struct(game).to_s
    end

    def build_fen_struct(game)
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

      rows_of_pieces = abbrev_rows.map(&:join).map{|row| squish_empty_spaces(row)}

      FenStruct.new({
                      rows_of_pieces: rows_of_pieces,
                      active_color: game.current_player.color[0]
                    })
    end

    def squish_empty_spaces(spaces)
      i = spaces.index(/\d\d/)

      if i
        next_str = get_next_str(i, spaces)

        squish_empty_spaces(next_str)
      else
        spaces
      end
    end

    def get_next_str(i, spaces)
      sum = (spaces[i].to_i + spaces[i + 1].to_i).to_s
      str_before_sum = if i == 0
                         ''
                       else
                         spaces[0..(i - 1)]
                       end
      str_after_sum = spaces[(i + 2)..-1]

      str_before_sum + sum + str_after_sum
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
