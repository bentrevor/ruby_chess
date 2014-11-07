module Moves
  class ForKnight
    class << self
      def for(board, starting_space)
        return [] unless board.pieces[starting_space].is_a? Knight

        @file = starting_space[0]
        @rank = starting_space[1].to_i

        target_spaces = l_spaces.select do |space|
          Utils.on_board?(space) && !colliding(board, starting_space, space)
        end

        Utils.spaces_to_moves(target_spaces, starting_space)
      end

      private

      def l_spaces
        ["#{dec_dec_file}#{@rank - 1}", "#{dec_dec_file}#{@rank + 1}",
         "#{dec_file}#{@rank - 2}",     "#{dec_file}#{@rank + 2}",
         "#{inc_inc_file}#{@rank - 1}", "#{inc_inc_file}#{@rank + 1}",
         "#{inc_file}#{@rank - 2}",     "#{inc_file}#{@rank + 2}"]
      end

      def inc_file()     Utils.inc_file(@file);                 end
      def inc_inc_file() Utils.inc_file(Utils.inc_file(@file)); end
      def dec_file()     Utils.dec_file(@file);                 end
      def dec_dec_file() Utils.dec_file(Utils.dec_file(@file)); end

      def colliding(board, starting_space, target_space)
        starting_piece = board.pieces[starting_space]
        target_piece = board.pieces[target_space]

        target_piece     &&
          starting_piece &&
          target_piece.color == starting_piece.color
      end
    end
  end
end
