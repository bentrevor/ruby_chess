require 'spec_helper'

describe Rules do
  let(:player1) { Player.new double, :white }
  let(:player2) { Player.new double, :black }

  let(:board) { Board.new({ 'd4' => white_rook,
                            'c3' => black_rook }) }

  let(:rules) { Rules.new(board, player1, player2) }

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

  describe 'game_over' do
    let(:game_over_board) { Board.new({ 'a1' => black_rook,
                                        'a2' => black_rook,
                                        'h1' => white_king }) }

    let(:game_over_rules) { Rules.new(game_over_board, player1, player2) }

    it 'knows when the game is over' do
      expect(rules.game_over?).to be false
      expect(game_over_rules.game_over?).to be true
    end

    it 'knows the winner' do
      expect(rules.winner).to be nil
      expect(game_over_rules.winner).to be player2
    end
  end
end
