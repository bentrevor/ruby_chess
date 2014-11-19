module Moves
  class ForCastling
    class << self
      def for(rules)
        self.new(rules).moves
      end
    end

    def initialize(rules)
      @rules = rules
      @player = rules.player
      @board = rules.board
      @starting_space = (@player.color == :white) ? 'e1' : 'e8'
    end

    def moves
      if can_castle?
        castle_moves
      else
        []
      end
    end

    private

    def can_castle?
      @board.pieces[@starting_space].is_a?(King) && !@rules.in_check?
    end

    def castle_moves
      moves = []

      moves << Move.new("#{@starting_space} c c#{home_rank(@player.color)}") if can_castle_left?
      moves << Move.new("#{@starting_space} c g#{home_rank(@player.color)}") if can_castle_right?

      moves
    end

    def can_castle_left?
      @spaces = if @player.color == :white
                 ['b1', 'c1', 'd1']
               else
                 ['b8', 'c8', 'd8']
               end

      @player.can_castle_left &&
        safe_castle_spaces?
    end

    def can_castle_right?
      @spaces = if @player.color == :white
                 ['f1', 'g1']
               else
                 ['f8', 'g8']
               end

      @player.can_castle_right &&
        safe_castle_spaces?
    end

    def safe_castle_spaces?
      correct_pieces      &&
        all_empty_spaces? &&
        !castling_through_check?
    end

    def correct_pieces
      rook_file = if @spaces.first[0] == 'b'
                    'a'
                  else
                    'h'
                  end

      rank = @spaces.first[1]
      rook_space = "#{rook_file}#{rank}"
      king_space = "e#{rank}"

      rook = @board.pieces[rook_space]
      king = @board.pieces[king_space]

      rook                          && king                       &&
        rook.is_a?(Rook)            && king.is_a?(King)           &&
        rook.color == @player.color && king.color == @player.color
    end

    def castling_through_check?
      castling_through_check = false
      color = @player.color
      rank = home_rank(color)

      target_spaces = @spaces.reject{ |s| s.include?('b') }

      target_spaces.each do |target_space|
        @board.try_move(Move.new("#{@starting_space} - #{target_space}")) do
          castling_through_check = true if @rules.in_check?
        end
      end

      castling_through_check
    end

    def all_empty_spaces?
      @spaces.each do |space|
        return false if @board.pieces[space]
      end
      true
    end

    def home_rank(color)
      (color == :white) ? 1 : 8
    end
  end
end
