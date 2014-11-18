require 'spec_helper'

describe Game do
  let(:first_move)  { Move.new('e2 - e4') }
  let(:second_move) { Move.new('e7 - e5') }
  let(:decider1)    { double 'move decider 1', :get_move => first_move }
  let(:decider2)    { double 'move decider 2', :get_move => second_move }
  let(:player1)     { Player.new(decider1, :white) }
  let(:player2)     { Player.new(decider2, :black) }
  let(:writer)      { class_double 'ConsoleWriter', :show => nil, :show_board => nil, :flash_message= => nil }
  let(:board)       { Board.new }
  let(:game)        { Game.new(player1, player2, writer, board) }

  let(:rules)   { Rules.new(board, player1, player2) }

  before :each do
    allow_any_instance_of(Rules).to receive(:game_over?).and_return false, false, true
    allow_any_instance_of(Rules).to receive(:winner)
    allow(player1).to receive(:color=)
    allow(player2).to receive(:color=)
  end

  it 'starts with two players and a board' do
    expect(game.current_player).to eq player1
    expect(game.other_player).to eq player2
    expect(game.board).to eq board
  end

  it 'assigns colors to the players' do
    expect(player1).to receive(:color=).with(:white)
    expect(player2).to receive(:color=).with(:black)

    game
  end

  it 'toggles players when a move is made' do
    game.next_turn

    expect(game.current_player).to eq player2
    expect(game.other_player).to eq player1
  end

  it 'makes a move in the board each turn' do
    expect(board).to receive(:move_piece).at_least(2).times
    game.next_turn
    game.next_turn
  end

  it 'only makes a valid move' do
    expect_any_instance_of(Rules).to receive(:valid_move?).with(first_move).and_return false
    expect(board).not_to receive(:move_piece)

    game.next_turn
  end

  it 'shows an invalid move message when a move is invalid' do
    expect_any_instance_of(Rules).to receive(:valid_move?).and_raise(Rules::InvalidMoveError.new('msg'))
    expect(writer).to receive(:flash_message=).with 'msg'
    expect(board).not_to receive(:move_piece)

    game.next_turn
  end

  it 'only toggles players after a valid move' do
    expect_any_instance_of(Rules).to receive(:valid_move?).with(first_move).and_return false
    game.next_turn

    expect(game.current_player).to eq player1
    expect(game.other_player).to eq player2
  end

  it 'makes the first turn when the game is started' do
    expect_any_instance_of(Rules).to receive(:game_over?).and_return false, true
    game.start

    expect(game.current_player).to eq player2
    expect(game.other_player).to eq player1
  end

  it 'gets a move from the players' do
    expect(player1).to receive(:get_move).and_return first_move
    expect(player2).to receive(:get_move).and_return second_move
    expect_any_instance_of(Rules).to receive(:game_over?).and_return false, false, true

    game.start
  end

  it 'checks for game over after each turn' do
    game.start
  end

  it 'can print out a tie game message' do
    expect(writer).to receive(:show).with('Tie game.')

    game.start
  end

  it 'prints out the board each turn' do
    expect(writer).to receive(:show_board).with(board)

    game.start
  end

  it "prints out the winner's name" do
    allow_any_instance_of(Rules).to receive(:winner).and_return :black
    expect(writer).to receive(:show).with('Black wins.')

    game.start
  end

  it 'can show all the moves for a piece' do
    target_spaces = ['a2', 'a3']

    expect(player1).to receive(:get_move).and_return Move.new('a1 moves')
    expect(player1).to receive(:pause)
    expect_any_instance_of(Rules).to receive(:all_moves_for_space).with('a1').and_return(target_spaces)
    expect(writer).to receive(:show).with(target_spaces)

    game.next_turn
  end
end
