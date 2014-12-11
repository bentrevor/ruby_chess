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

  let(:new_game_fen_struct) { described_class.call(game) }

  it 'has all the pieces' do
    rows = new_game_fen_struct.rows_of_pieces

    expect(rows).to include 'rnbqkbnr'
    expect(rows).to include 'pppppppp'
    expect(rows).to include '/8/8/8/8/'
    expect(rows).to include 'RNBQKBNR'
    expect(rows).to include 'PPPPPPPP'
  end

  it 'knows the current player' do
    expect(new_game_fen_struct.current_player).to eq 'w'

    game.next_move
    next_turn_fen_struct = described_class.call(game)

    expect(new_game_fen_struct.current_player).to eq 'b'
  end
end
