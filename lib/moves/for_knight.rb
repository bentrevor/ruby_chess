module Moves
  class ForKnight
    class << self
      def for(board, starting_space)
        return [] unless board.pieces[starting_space].is_a? Knight

        @file = starting_space[0]
        @rank = starting_space[1].to_i

        l_moves.select do |space|
          space.length == 2 and
            !off_board?(space[0], space[1].to_i) and
            !colliding(board, starting_space, space)
        end
      end

      def l_moves
        ["#{dec_dec_file}#{@rank - 1}", "#{dec_dec_file}#{@rank + 1}",
         "#{dec_file}#{@rank - 2}",     "#{dec_file}#{@rank + 2}",
         "#{inc_inc_file}#{@rank - 1}", "#{inc_inc_file}#{@rank + 1}",
         "#{inc_file}#{@rank - 2}",     "#{inc_file}#{@rank + 2}"]
      end

      def inc_file
        Utils.inc_file(@file)
      end

      def inc_inc_file
        Utils.inc_file(Utils.inc_file(@file))
      end

      def dec_file
        Utils.dec_file(@file)
      end

      def dec_dec_file
        Utils.dec_file(Utils.dec_file(@file))
      end

      def off_board?(file, rank)
        file < 'a' or file > 'h' or rank < 1 or rank > 8
      end

      def colliding(board, starting_space, target_space)
        starting_piece = board.pieces[starting_space]
        target_piece = board.pieces[target_space]

        if target_piece and starting_piece and target_piece.color == starting_piece.color
          true
        else
          false
        end
      end
    end
  end
end
