require 'spec_helper'

describe Rules do
  let(:black_bishop) { Piece.create :black, :bishop }
  let(:black_king)   { Piece.create :black, :king }
  let(:black_knight) { Piece.create :black, :knight }
  let(:black_pawn)   { Piece.create :black, :pawn }
  let(:black_rook)   { Piece.create :black, :rook }
  let(:white_bishop) { Piece.create :white, :bishop }
  let(:white_king)   { Piece.create :white, :king }
  let(:white_pawn)   { Piece.create :white, :pawn }
  let(:white_rook)   { Piece.create :white, :rook }

  let(:player1) { Player.new double, :white }
  let(:player2) { Player.new double, :black }

  let(:board) { Board.new({ 'd4' => white_rook,
                            'c3' => black_rook }) }

  let(:rules) { Rules.new(board, player1, player2) }

  describe '#valid_move?' do
    it 'knows when a move is valid' do
      expect(rules.valid_move?(Move.new('d4 - d5'))).to eq true
    end

    it 'is false when there is no piece in original space' do
      expect { rules.valid_move?(Move.new('a4 - a5')) }.to raise_error(Rules::InvalidMoveError)
    end

    it 'is false when it tries to move the wrong color piece' do
      expect { rules.valid_move?(Move.new('c3 - c4')) }.to raise_error(Rules::InvalidMoveError)
    end

    it 'is false when it tries to make an illegal move' do
      expect(  rules.valid_move?(Move.new('d4 - d8'))).to eq true
      expect(  rules.valid_move?(Move.new('d4 - h4'))).to eq true
      expect { rules.valid_move?(Move.new('d4 - e5')) }.to raise_error(Rules::InvalidMoveError)
    end

    it 'raises an error when a pawn promotion is not specified' do
      board = Board.new({ :d7 => white_pawn })
      rules = Rules.new(board, player1, player2)

      expect { rules.valid_move?(Move.new('d7 - d8')) }.to raise_error(Rules::InvalidMoveError)
      expect(  rules.valid_move?(Move.new('d7 k d8'))).to eq true
      expect(  rules.valid_move?(Move.new('d7 b d8'))).to eq true
      expect(  rules.valid_move?(Move.new('d7 r d8'))).to eq true
      expect(  rules.valid_move?(Move.new('d7 q d8'))).to eq true
    end

    it "doesn't let you move into check" do
      board.place_piece(white_king, 'b2')

      %w[a3 b3 c2 c1].each do |invalid_move|
        expect { rules.valid_move?(Move.new("b2 - #{invalid_move}")) }.to raise_error(Rules::InvalidMoveError)
      end

      %w[a2 a1 b1 c3].each do |valid_move|
        expect(rules.valid_move?(Move.new("b2 - #{valid_move}"))).to eq true
      end
    end

    it 'forces you to move out of check' do
      board.place_piece(white_king, 'c2')

      expect { rules.valid_move?(Move.new('c2 - c1')) }.to raise_error(Rules::InvalidMoveError)
      expect { rules.valid_move?(Move.new('d4 - e4')) }.to raise_error(Rules::InvalidMoveError)

      expect(  rules.valid_move?(Move.new('c2 - b2'))).to eq true
      expect(  rules.valid_move?(Move.new('c2 - d1'))).to eq true
      expect(  rules.valid_move?(Move.new('c2 - c3'))).to eq true
    end
  end

  describe '#in_check?' do
    it 'knows when the king is in check' do
      board.place_piece(black_king, 'd8')
      board.place_piece(white_king, 'h8')

      expect(Rules.new(board, player1, player2).in_check?).to be false
      expect(Rules.new(board, player2, player1).in_check?).to be true
    end

    specify 'a knight can put a king in check' do
      board.place_piece(white_king, 'e8')
      board.place_piece(black_knight, 'f6')

      expect(rules.in_check?).to be true
    end

    specify 'a pawn can put a king in check' do
      board.place_piece(white_king, 'd4')
      board.place_piece(black_pawn, 'e5')

      expect(rules.in_check?).to be true
    end
  end

  describe '#all_moves_for_space' do
    def moves_for(space)
      rules.all_moves_for_space(space).map(&:text).sort
    end

    it 'lists all moves for a piece' do
      board.place_piece(white_king, 'a8')

      expect(rules.all_moves_for_space('a7')).to be_empty
      expect(moves_for('a8')).to eq ['a8 - a7', 'a8 - b7', 'a8 - b8']
    end

    it 'includes pawn moves' do
      board.place_piece(white_pawn, 'a2')
      expect(moves_for('a2')).to eq ['a2 - a3', 'a2 - a4']

      board.place_piece(black_rook, 'b3')
      expect(moves_for('a2')).to include 'a2 - b3'
    end

    it 'includes castle moves' do
      board.place_piece(white_king, 'e1')
      board.place_piece(white_rook, 'h1')

      expect(moves_for('e1')).not_to include 'e1 c c1'
      expect(moves_for('e1')).to include 'e1 c g1'
    end
  end

  describe '#all_moves_for_player' do
    it 'lists every move a player can make' do
      board.place_piece(white_king, 'd4')
      moves = rules.all_moves_for_player.map(&:text).sort

      expect(moves).not_to include 'd4 - c5'
      expect(moves).not_to include 'd4 - c4'
      expect(moves).not_to include 'd4 - d3'
      expect(moves).not_to include 'd4 - e3'
      expect(moves).to include 'd4 - c3'
      expect(moves).to include 'd4 - d5'
      expect(moves).to include 'd4 - e4'

      board.place_piece(white_rook, 'a1')
      moves = rules.all_moves_for_player.map(&:text).sort

      expect(moves).to include 'a1 - a2'
      expect(moves).to include 'a1 - a8'
    end
  end

  describe 'game_over' do
    let(:game_over_board) { Board.new({ 'a1' => black_rook,
                                        'a2' => black_rook,
                                        'h1' => white_king }) }

    let(:game_over_rules) { Rules.new(game_over_board, player1, player2) }

    it 'knows when the game is over' do
      expect(rules.game_over?).to be false
      expect(game_over_rules.game_over?).to be true
    end
  end
end
