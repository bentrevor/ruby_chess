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

  def move_piece(move)
    original_space = get_space(move.split.first)

    place_piece(original_space.piece, move.split.last)
    original_space.piece = nil
  end

  def place_piece(piece, space)
    get_space(space).piece = piece
  end

  def get_space(space)
    file = space[0]
    rank = space[1].to_i

    spaces.find { |s| s.rank == rank and s.file == file }
  end

  def get_piece(space)
    get_space(space).piece
  end

  def pieces
    spaces.each_with_object({}) do |s, acc|
      acc["#{s.file}#{s.rank}"] = s.piece if s.piece
    end
  end

  private

  def right_edge_space(index)
    (index + 1) % 8 == 0
  end

  def starting_pieces(pieces)
    self.spaces = (0..63).map { |index| Space.new(file_for(index), rank_for(index), nil) }

    pieces.each_pair do |space, piece|
      place_piece piece, space
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
      Piece.create(color, piece_type_for(file))
    elsif rank == 2 or rank == 7
      Piece.create(color, :pawn)
    end
  end

  def build_initial_space_for(index)
    return Space.new('a', 1, Piece.create(:white, :rook)) if index == 0 # can't divide by 0

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
    (0..63).map { |index| build_initial_space_for index }
  end
end
