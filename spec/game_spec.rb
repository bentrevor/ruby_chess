require 'spec_helper'

describe Game do
  let(:first_move) { 'a1 - a2' }
  let(:second_move) { 'b1 - b2' }
  let(:player1) { double 'human player', :get_move => first_move, :color => :white }
  let(:player2) { double 'computer player', :get_move => second_move, :color => :black }
  let(:rules)   { double 'game rules', :game_over? => true, :winner => nil, :valid_move? => true }
  let(:writer)  { double 'writer', :show => nil, :show_board => nil }
  let(:board)   { double 'board', :spaces => 'spaces', :move_piece => nil }
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
    expect(board).to receive(:move_piece).with(first_move)
    game.next_turn
    expect(board).to receive(:move_piece).with(second_move)
    game.next_turn
  end

  it 'only makes a valid move' do
    expect(rules).to receive(:valid_move?).with(first_move, board, player1).and_return false
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
    expect(rules).to receive(:game_over?).with(board)
    game.start
  end

  it 'can print out a tie game message' do
    expect(writer).to receive(:show).with('Tie game.')

    game.start
  end

  it 'prints out the board each turn' do
    expect(writer).to receive(:show_board).with(board)

    game.next_turn
  end

  it "prints out the winner's name" do
    allow(rules).to receive(:winner).and_return :black
    expect(writer).to receive(:show).with('Black wins.')

    game.start
  end
end
