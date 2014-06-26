require 'spec_helper'

describe Piece do
  let(:rook)   { PieceFactory.create :black, :rook }
  let(:bishop) { PieceFactory.create :black, :bishop }
  let(:queen)  { PieceFactory.create :black, :queen }
  let(:king)   { PieceFactory.create :black, :king }
  let(:knight) { PieceFactory.create :black, :knight }
  let(:pawn)   { PieceFactory.create :black, :pawn }

  it 'knows how to move' do
    rook.directions.should include :north
    rook.directions.should include :south
    rook.directions.should include :east
    rook.directions.should include :west

    bishop.directions.should include :northeast
    bishop.directions.should include :northwest
    bishop.directions.should include :southeast
    bishop.directions.should include :southwest

    queen.directions.should include :north
    queen.directions.should include :south
    queen.directions.should include :east
    queen.directions.should include :west
    queen.directions.should include :northeast
    queen.directions.should include :northwest
    queen.directions.should include :southeast
    queen.directions.should include :southwest

    king.directions.should include :north
    king.directions.should include :south
    king.directions.should include :east
    king.directions.should include :west
    king.directions.should include :northeast
    king.directions.should include :northwest
    king.directions.should include :southeast
    king.directions.should include :southwest
  end

  it 'knows how far it can move' do
    king.limit.should == 1
    pawn.limit.should == 1
    queen.limit.should == 8
  end

  context 'legal moves' do
    let(:board) { ChessBoard.new({}) }

    specify 'direction == east' do
      board.get_space('a1').piece = rook

      ('b'..'h').each do |file|
        rook.available_moves(board, 'a1').should include "#{file}1"
      end
    end

    specify 'direction == north' do
      board.get_space('a1').piece = rook

      (2..8).each do |rank|
        rook.available_moves(board, 'a1').should include "a#{rank}"
      end
    end

    specify 'direction == west' do
      board.get_space('h8').piece = rook

      ('a'..'g').each do |file|
        rook.available_moves(board, 'h8').should include "#{file}8"
      end
    end

    specify 'direction == south' do
      board.get_space('h8').piece = rook

      (1..7).each do |rank|
        rook.available_moves(board, 'h8').should include "h#{rank}"
      end
    end

    specify 'direction == southwest' do
      board.get_space('h8').piece = bishop

      (1..7).each do |i|
        file = (104 - i).chr
        rank = 8 - i

        bishop.available_moves(board, 'h8').should include "#{file}#{rank}"
      end
    end

    specify 'direction == northeast' do
      board.get_space('a1').piece = bishop

      (2..8).each do |rank|
        file = (96 + rank).chr
        bishop.available_moves(board, 'a1').should include "#{file}#{rank}"
      end
    end

    specify 'direction == southeast' do
      board.get_space('a8').piece = bishop

      (1..7).each do |i|
        file = (97 + i).chr
        rank = 8 - i
        bishop.available_moves(board, 'a8').should include "#{file}#{rank}"
      end
    end

    specify 'direction == northwest' do
      board.get_space('h1').piece = bishop

      (2..8).each do |rank|
        file = (105 - rank).chr
        bishop.available_moves(board, 'h1').should include "#{file}#{rank}"
      end
    end
  end
end
