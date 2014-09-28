require 'spec_helper'

describe ChessRules do
  let(:white_bishop) { Piece.create :black, :bishop }
  let(:black_king)   { Piece.create :black, :king }
  let(:black_pawn)   { Piece.create :black, :pawn }
  let(:black_rook)   { Piece.create :black, :rook }
  let(:white_bishop) { Piece.create :white, :bishop }
  let(:white_king)   { Piece.create :white, :king }
  let(:white_pawn)   { Piece.create :white, :pawn }
  let(:white_rook)   { Piece.create :white, :rook }

  let(:player1) { Player.new double, :white }
  let(:player2) { Player.new double, :black }

  let(:board) { ChessBoard.new({'d4' => white_rook}) }

  describe '#valid_move?' do
    it 'knows when a move is valid' do
      expect(ChessRules.valid_move?('d4 - d5', board, player1)).to eq true
    end

    it 'is false when there is no piece in original space' do
      expect(ChessRules.valid_move?('a4 - a5', board, player1)).to eq false
    end

    it 'is false when it tries to move the wrong color piece' do
      expect(ChessRules.valid_move?('d4 - d5', board, player2)).to eq false
    end

    it 'is false when it tries to make an illegal move' do
      expect(ChessRules.valid_move?('d4 - d8', board, player1)).to eq true
      expect(ChessRules.valid_move?('d4 - h4', board, player1)).to eq true
      expect(ChessRules.valid_move?('d4 - e5', board, player1)).to eq false
    end

    it "doesn't let you move into check" do
      board.place_piece(black_king, 'c3')

      %w[b4 c4 d3 d2].each do |invalid_move|
        expect(ChessRules.valid_move?("c3 - #{invalid_move}", board, player2)).to eq false
      end

      %w[b3 b2 c2 d4].each do |valid_move|
        expect(ChessRules.valid_move?("c3 - #{valid_move}", board, player2)).to eq true
      end

      board.place_piece(white_bishop, 'e5')
      expect(ChessRules.valid_move?("c3 - d4", board, player2)).to eq false
    end

    it 'forces you to move out of check' do
      board.place_piece(black_king, 'c4')
      board.place_piece(black_rook, 'e4')

      expect(ChessRules.valid_move?('e4 - e5', board, player2)).to eq false
      expect(ChessRules.valid_move?('e4 - d4', board, player2)).to eq true

      expect(ChessRules.valid_move?('c4 - b4', board, player2)).to eq false
      expect(ChessRules.valid_move?('c4 - d5', board, player2)).to eq false
      expect(ChessRules.valid_move?('c4 - c5', board, player2)).to eq true
      expect(ChessRules.valid_move?('c4 - d4', board, player2)).to eq true
    end

    describe 'castling:' do
      let(:board) { ChessBoard.new({ 'a1' => white_rook,
                                     'h1' => white_rook,
                                     'e1' => white_king }) }

      specify 'a player can castle when no pieces are in the way' do
        expect(ChessRules.valid_move?('e1 - c1', board, player1)).to eq true

        board.place_piece(white_king, 'e1')
        expect(ChessRules.valid_move?('e1 - g1', board, player1)).to eq true
      end

      specify "a player can't castle if there are pieces in the way" do
        board.place_piece(white_bishop, 'b1')
        board.place_piece(white_bishop, 'f1')

        expect(ChessRules.valid_move?('e1 - c1', board, player1)).to eq false
        expect(ChessRules.valid_move?('e1 - g1', board, player1)).to eq false
      end

      specify "a player can't castle if they have moved their king or rook"
      specify "a player can't castle out of check"
      specify "a player can't castle through check"
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
