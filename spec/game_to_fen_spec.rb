require 'spec_helper'

describe GameToFen do
  let(:first_move)  { Move.new('e2 - e4') }
  let(:second_move) { Move.new('e7 - e5') }
  let(:decider1)    { double 'move decider 1', :get_move => first_move }
  let(:decider2)    { double 'move decider 2', :get_move => second_move }
  let(:player1)     { Player.new(decider1, :white) }
  let(:player2)     { Player.new(decider2, :black) }
  let(:writer)      { class_double 'ConsoleWriter', :show => nil, :show_board => nil, :flash_message= => nil }
  let(:board)       { Board.new }
  let(:game)        { Game.new(player1, player2, writer, board) }

  let(:new_game_fen_struct) { described_class.build_fen_struct(game) }

  def fen_struct
    described_class.build_fen_struct(game)
  end

  it 'has all the pieces' do
    rows = new_game_fen_struct.rows_of_pieces

    expect(rows).to include 'rnbqkbnr'
    expect(rows).to include 'pppppppp'
    expect(rows).to include '/8/8/8/8/'
    expect(rows).to include 'RNBQKBNR'
    expect(rows).to include 'PPPPPPPP'
  end

  it 'knows the current player' do
    expect(new_game_fen_struct.active_color).to eq 'w'

    game.next_turn
    next_turn_fen_struct = described_class.build_fen_struct(game)

    expect(next_turn_fen_struct.active_color).to eq 'b'
  end

  it 'knows the castling availability' do
    expect(new_game_fen_struct.castling_availability).to eq 'KQkq'

    player1.can_castle_left  = false
    player2.can_castle_right = false

    expect(fen_struct.castling_availability).to eq 'Kq'

    player1.can_castle_right = false
    player2.can_castle_left  = false

    expect(fen_struct.castling_availability).to eq '-'
  end

  it 'knows the en passant capture space' do
    expect(fen_struct.en_passant_target_space).to eq '-'
    game.next_turn
    expect(fen_struct.en_passant_target_space).to eq 'e3'
  end

  it 'stubs the halfmove_clock' do
    # complete implementation of chess rules is out of the scope of this project :)
    expect(fen_struct.halfmove_clock).to eq '0'
  end

  it 'knows how many moves have been made' do
    expect(fen_struct.fullmove_number).to eq '1'

    game.next_turn
    expect(fen_struct.fullmove_number).to eq '1'

    game.next_turn
    expect(fen_struct.fullmove_number).to eq '2'
  end
end
