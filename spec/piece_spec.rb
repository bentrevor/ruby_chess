require 'spec_helper'

describe Piece do
  let(:rook)   { PieceFactory.create :black, :rook }
  let(:bishop) { PieceFactory.create :black, :bishop }
  let(:queen)  { PieceFactory.create :black, :queen }
  let(:king)   { PieceFactory.create :black, :king }
  let(:knight) { PieceFactory.create :black, :knight }
  let(:pawn)   { PieceFactory.create :black, :pawn }

  it 'knows how to move' do
    expect(rook.directions).to include :north
    expect(rook.directions).to include :south
    expect(rook.directions).to include :east
    expect(rook.directions).to include :west

    expect(bishop.directions).to include :northeast
    expect(bishop.directions).to include :northwest
    expect(bishop.directions).to include :southeast
    expect(bishop.directions).to include :southwest

    expect(queen.directions).to include :north
    expect(queen.directions).to include :south
    expect(queen.directions).to include :east
    expect(queen.directions).to include :west
    expect(queen.directions).to include :northeast
    expect(queen.directions).to include :northwest
    expect(queen.directions).to include :southeast
    expect(queen.directions).to include :southwest

    expect(king.directions).to include :north
    expect(king.directions).to include :south
    expect(king.directions).to include :east
    expect(king.directions).to include :west
    expect(king.directions).to include :northeast
    expect(king.directions).to include :northwest
    expect(king.directions).to include :southeast
    expect(king.directions).to include :southwest
  end

  it 'knows how far it can move' do
    expect(king.limit).to eq 1
    expect(pawn.limit).to eq 1
    expect(queen.limit).to eq 8
  end

  context 'legal moves' do
    let(:board) { ChessBoard.new({}) }

    specify 'direction == east' do
      board.get_space('a1').piece = rook

      ('b'..'h').each do |file|
        expect(rook.available_moves(board, 'a1')).to include "#{file}1"
      end
    end

    specify 'direction == north' do
      board.get_space('a1').piece = rook

      (2..8).each do |rank|
        expect(rook.available_moves(board, 'a1')).to include "a#{rank}"
      end
    end

    specify 'direction == west' do
      board.get_space('h8').piece = rook

      ('a'..'g').each do |file|
        expect(rook.available_moves(board, 'h8')).to include "#{file}8"
      end
    end

    specify 'direction == south' do
      board.get_space('h8').piece = rook

      (1..7).each do |rank|
        expect(rook.available_moves(board, 'h8')).to include "h#{rank}"
      end
    end

    specify 'direction == southwest' do
      board.get_space('h8').piece = bishop

      (1..7).each do |i|
        file = (104 - i).chr
        rank = 8 - i

        expect(bishop.available_moves(board, 'h8')).to include "#{file}#{rank}"
      end
    end

    specify 'direction == northeast' do
      board.get_space('a1').piece = bishop

      (2..8).each do |rank|
        file = (96 + rank).chr
        expect(bishop.available_moves(board, 'a1')).to include "#{file}#{rank}"
      end
    end

    specify 'direction == southeast' do
      board.get_space('a8').piece = bishop

      (1..7).each do |i|
        file = (97 + i).chr
        rank = 8 - i
        expect(bishop.available_moves(board, 'a8')).to include "#{file}#{rank}"
      end
    end

    specify 'direction == northwest' do
      board.get_space('h1').piece = bishop

      (2..8).each do |rank|
        file = (105 - rank).chr
        expect(bishop.available_moves(board, 'h1')).to include "#{file}#{rank}"
      end
    end
  end
end
