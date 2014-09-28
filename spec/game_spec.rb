require 'spec_helper'

describe Game do
  let(:first_move) { 'e2 - e4' }
  let(:second_move) { 'e7 - e5' }
  let(:player1) { instance_double 'Player', :get_move => first_move, :color => :white }
  let(:player2) { instance_double 'Player', :get_move => second_move, :color => :black }
  let(:rules)   { ChessRules }
  let(:writer)  { class_double 'ConsoleWriter', :show => nil, :show_board => nil }
  let(:board)   { instance_double 'ChessBoard', :spaces => 'spaces', :move_piece => nil }
  let(:board)   { ChessBoard.new }
  let(:game)    { Game.new(player1, player2, rules, writer, board) }

  before :each do
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
    expect(rules).to receive(:valid_move?).with(first_move, board, player1).and_return false
    expect(board).not_to receive(:move_piece)

    game.next_turn
  end

  it 'shows an invalid move message when a move is invalid' do
    expect(rules).to receive(:valid_move?).and_raise(ChessRules::InvalidMoveError.new('msg'))
    expect(writer).to receive(:flash_message=).with 'msg'
    expect(board).not_to receive(:move_piece)

    game.next_turn
  end

  it 'only toggles players after a valid move' do
    expect(rules).to receive(:valid_move?).with(first_move, board, player1).and_return false
    game.next_turn

    expect(game.current_player).to eq player1
    expect(game.other_player).to eq player2
  end

  it 'makes the first turn when the game is started' do
    expect(rules).to receive(:game_over?).with(board).and_return false, true
    game.start

    expect(game.current_player).to eq player2
    expect(game.other_player).to eq player1
  end

  it 'gets a move from the players' do
    expect(player1).to receive(:get_move)
    expect(player2).to receive(:get_move)
    expect(rules).to receive(:game_over?).with(board).and_return false, false, true

    game.start
  end

  it 'checks for game over after each turn' do
    expect(rules).to receive(:game_over?).with(board).and_return false, false, true
    game.start
  end

  it 'can print out a tie game message' do
    expect(rules).to receive(:game_over?).with(board).and_return false, false, true
    expect(writer).to receive(:show).with('Tie game.')

    game.start
  end

  it 'prints out the board each turn' do
    expect(rules).to receive(:game_over?).with(board).and_return false, false, true
    expect(writer).to receive(:show_board).with(board)

    game.start
  end

  it "prints out the winner's name" do
    expect(rules).to receive(:game_over?).with(board).and_return false, false, true
    allow(rules).to receive(:winner).and_return :black
    expect(writer).to receive(:show).with('Black wins.')

    game.start
  end
end
