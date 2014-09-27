require 'spec_helper'

describe ChessRules do
  let(:white_rook)   { Piece.create :white, :rook }
  let(:white_king)   { Piece.create :white, :king }
  let(:black_king)   { Piece.create :black, :king }
  let(:black_pawn)   { Piece.create :black, :pawn }
  let(:white_pawn)   { Piece.create :white, :pawn }
  let(:white_bishop) { Piece.create :white, :bishop }

  let(:board) { ChessBoard.new({'d4' => white_rook}) }

  describe '#valid_move?' do
    it 'knows when a move is valid' do
      expect(ChessRules.valid_move?('d4 - d5', board, :white)).to eq true
    end

    it 'is false when there is no piece in original space' do
      expect(ChessRules.valid_move?('a4 - a5', board, :white)).to eq false
    end

    it 'is false when it tries to move the wrong color piece' do
      expect(ChessRules.valid_move?('d4 - d5', board, :black)).to eq false
    end

    it 'is false when it tries to make an illegal move' do
      expect(ChessRules.valid_move?('d4 - d8', board, :white)).to eq true
      expect(ChessRules.valid_move?('d4 - h4', board, :white)).to eq true
      expect(ChessRules.valid_move?('d4 - e5', board, :white)).to eq false
    end

    xit "doesn't let you move into check" do
      board.place_piece(black_king, 'c3')

      %w[b4 c4 d3 d2].each do |invalid_move|
        expect(ChessRules.valid_move?("c3 - #{invalid_move}", board, :black)).to eq false
      end

      %w[b3 b2 c2 d4].each do |valid_move|
        expect(ChessRules.valid_move?("c3 - #{valid_move}", board, :black)).to eq false
      end
    end
  end

  describe '#in_check?' do
    it 'knows when the king is in check' do
      board.place_piece(black_king, 'd8')
      board.place_piece(white_king, 'h8')

      expect(ChessRules.in_check?(board, :white)).to be false
      expect(ChessRules.in_check?(board, :black)).to be true
    end
  end
end
