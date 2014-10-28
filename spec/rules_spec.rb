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

  let(:board) { Board.new({'d4' => white_rook}) }

  describe '#valid_move?' do
    it 'knows when a move is valid' do
      expect(Rules.valid_move?('d4 - d5', board, player1)).to eq true
    end

    it 'is false when there is no piece in original space' do
      expect { Rules.valid_move?('a4 - a5', board, player1) }.to raise_error(Rules::InvalidMoveError)
    end

    it 'is false when it tries to move the wrong color piece' do
      expect { Rules.valid_move?('d4 - d5', board, player2) }.to raise_error(Rules::InvalidMoveError)
    end

    it 'is false when it tries to make an illegal move' do
      expect(Rules.valid_move?('d4 - d8', board, player1)).to eq true
      expect(Rules.valid_move?('d4 - h4', board, player1)).to eq true
      expect { Rules.valid_move?('d4 - e5', board, player1) }.to raise_error(Rules::InvalidMoveError)
    end

    it "doesn't let you move into check" do
      board.place_piece(black_king, 'c3')

      %w[b4 c4 d3 d2].each do |invalid_move|
        expect { Rules.valid_move?("c3 - #{invalid_move}", board, player2) }.to raise_error(Rules::InvalidMoveError)
      end

      %w[b3 b2 c2 d4].each do |valid_move|
        expect(Rules.valid_move?("c3 - #{valid_move}", board, player2)).to eq true
      end

      board.place_piece(white_bishop, 'e5')
      expect { Rules.valid_move?("c3 - d4", board, player2) }.to raise_error(Rules::InvalidMoveError)
    end

    it 'forces you to move out of check' do
      board.place_piece(black_king, 'c4')
      board.place_piece(black_rook, 'e4')

      expect { Rules.valid_move?('e4 - e5', board, player2) }.to raise_error(Rules::InvalidMoveError)
      expect(Rules.valid_move?('e4 - d4', board, player2)).to eq true

      expect { Rules.valid_move?('c4 - b4', board, player2) }.to raise_error(Rules::InvalidMoveError)
      expect { Rules.valid_move?('c4 - d5', board, player2) }.to raise_error(Rules::InvalidMoveError)
      expect(Rules.valid_move?('c4 - c5', board, player2)).to eq true
      expect(Rules.valid_move?('c4 - d4', board, player2)).to eq true
    end
  end

  describe '#in_check?' do
    it 'knows when the king is in check' do
      board.place_piece(black_king, 'd8')
      board.place_piece(white_king, 'h8')

      expect(Rules.in_check?(board, :white)).to be false
      expect(Rules.in_check?(board, :black)).to be true
    end

    # regression specs
    specify 'a knight can put a king in check' do
      board.place_piece(white_king, 'e8')
      board.place_piece(black_knight, 'f6')

      expect(Rules.in_check?(board, :white)).to be true
    end
  end

  describe '#all_moves_for_space' do
    it 'lists all moves for a piece' do
      board.place_piece(white_king, 'a8')

      expect(Rules.all_moves_for_space('a7', board)).to be_empty
      expect(Rules.all_moves_for_space('a8', board).sort).to eq %w[a7 b7 b8]
    end
  end
end
