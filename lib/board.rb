class ChessBoard
  attr_accessor :spaces

  class Space < Struct.new(:file, :rank, :piece)
  end

  def initialize(pieces=nil)
    self.spaces = if pieces
                    starting_pieces(pieces)
                  else
                    initial_layout
                  end
  end

  def piece_at(space)
    space = get_space(space)

    space.piece
  end

  def place_move(move)
    original_space = get_space(move.split.first)
    new_space = get_space(move.split.last)
    piece_to_move = original_space.piece

    new_space.piece = piece_to_move
    original_space.piece = nil
  end

  def get_space(space)
    file = space[0]
    rank = space[1].to_i

    spaces.select {|s| s.rank == rank}.find {|s| s.file == file}
  end

  private

  def starting_pieces(pieces)
    self.spaces = (0..63).map { |index| Space.new(file_for(index), rank_for(index), nil) }

    pieces.each_pair do |space, piece|
      get_space(space).piece = piece
    end

    self.spaces
  end

  def color_for(rank)
    (rank < 3) ? :white : :black
  end

  def piece_type_for(file)
    {
      'a' => :rook,
      'b' => :knight,
      'c' => :bishop,
      'd' => :queen,
      'e' => :king,
      'f' => :bishop,
      'g' => :knight,
      'h' => :rook
    }[file]
  end

  def piece_for(file, rank)
    color = color_for rank

    if rank == 1 or rank == 8
      Piece.new(piece_type_for(file), color)
    elsif rank == 2 or rank == 7
      Piece.new(:pawn, color)
    end
  end

  def build_space_for(index)
    return Space.new('a', 1, Piece.new(:rook, :white)) if index == 0 # can't divide by 0

    file = file_for index
    rank = rank_for index

    Space.new(file, rank, piece_for(file, rank))
  end

  def file_for(index)
    ('a'.ord + (index % 8)).chr
  end

  def rank_for(index)
    (index / 8) + 1
  end

  def initial_layout
    (0..63).map { |index| build_space_for index }
  end
end

class EchoBoard
  attr_accessor :spaces

  def initialize
    self.spaces = ''
  end

  def place_move(move)
    spaces << move
  end
end
