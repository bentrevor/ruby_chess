require 'game'
require 'pry'

describe Game do
  let(:first_move) { 1 }
  let(:second_move) { 2 }
  let(:player1) { double 'human player', :get_move => first_move }
  let(:player2) { double 'computer player', :get_move => second_move }
  let(:rules)   { double 'game rules', :game_over? => true, :winner => nil, :valid_move? => true }
  let(:writer)  { double 'writer', :show => nil, :show_board => nil }
  let(:board)   { double 'board', :spaces => 'spaces', :place_move => nil }
  let(:game)    { Game.new(player1, player2, rules, writer, board) }

  it 'starts with two players and a board' do
    game.current_player.should == player1
    game.other_player.should == player2
    game.board.should == board
  end

  it 'toggles players when a move is made' do
    game.next_turn

    game.current_player.should == player2
    game.other_player.should == player1
  end

  it 'places a move in the board each turn' do
    board.should_receive(:place_move).with(first_move)
    game.next_turn
    board.should_receive(:place_move).with(second_move)
    game.next_turn
  end

  it 'only places a valid move' do
    rules.should_receive(:valid_move?).with(first_move).and_return false
    board.should_not_receive(:place_move)

    game.next_turn
  end

  it 'only toggles players after a valid move' do
    rules.should_receive(:valid_move?).with(first_move).and_return false
    game.next_turn

    game.current_player.should == player1
    game.other_player.should == player2
  end

  it 'makes the first turn when the game is started' do
    rules.should_receive(:game_over?).with(board).and_return false, true
    game.start

    game.current_player.should == player2
    game.other_player.should == player1
  end

  it 'gets a move from the players' do
    player1.should_receive(:get_move)
    player2.should_receive(:get_move)
    rules.should_receive(:game_over?).with(board).and_return false, false, true

    game.start
  end

  it 'checks for game over after each turn' do
    rules.should_receive(:game_over?).with(board)
    game.start
  end

  it 'can print out a tie game message' do
    writer.should_receive(:show).with('Tie game.')

    game.start
  end

  it 'prints out the board each turn' do
    writer.should_receive(:show_board).with(board)

    game.next_turn
  end

  it "prints out the winner's name" do
    rules.stub(:winner).and_return :black
    writer.should_receive(:show).with('Black wins.')

    game.start
  end
end
