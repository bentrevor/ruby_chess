class Board
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
    raise ArgumentError unless Utils.correctly_formatted_move?(move)
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

    spaces.find { |s| s.rank == rank && s.file == file }
  end

  def pieces
    spaces.each_with_object({}) do |s, acc|
      acc["#{s.file}#{s.rank}"] = s.piece if s.piece
    end
  end

  def try_move(move)
    raise ArgumentError unless Utils.correctly_formatted_move?(move)
    starting_space = move.split.first
    target_space = move.split.last
    starting_piece = pieces[starting_space]
    target_piece = pieces[target_space]

    move_piece move
    yield

    get_space(starting_space).piece = starting_piece
    get_space(target_space).piece   = target_piece
  end

  def move_in_direction(space, direction)
    file = space[0]
    rank = space[1].to_i
    inc_file = Utils.inc_file(file)
    dec_file = Utils.dec_file(file)

    {
      :north     => "#{file}#{rank + 1}",
      :east      => "#{inc_file}#{rank}",
      :south     => "#{file}#{rank - 1}",
      :west      => "#{dec_file}#{rank}",
      :northeast => "#{inc_file}#{rank + 1}",
      :southeast => "#{inc_file}#{rank - 1}",
      :southwest => "#{dec_file}#{rank - 1}",
      :northwest => "#{dec_file}#{rank + 1}"
    }[direction]
  end

  private

  def starting_pieces(pieces)
    self.spaces = (0..63).map { |index| Space.new(file_for_index(index), rank_for_index(index), nil) }

    pieces.each_pair do |space, piece|
      place_piece piece, space
    end

    self.spaces
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

  def initial_piece_for(file, rank)
    color = (rank < 3) ? :white : :black

    if rank == 1 || rank == 8
      Piece.create(color, piece_type_for(file))
    elsif rank == 2 || rank == 7
      Piece.create(color, :pawn)
    end
  end

  def build_initial_space_for(index)
    if index == 0 # can't divide by 0
      return Space.new('a', 1, Piece.create(:white, :rook))
    end

    file = file_for_index(index)
    rank = rank_for_index(index)

    Space.new(file, rank, initial_piece_for(file, rank))
  end

  def file_for_index(index)
    ('a'.ord + (index % 8)).chr
  end

  def rank_for_index(index)
    (index / 8) + 1
  end

  def initial_layout
    (0..63).map { |index| build_initial_space_for index }
  end
end
