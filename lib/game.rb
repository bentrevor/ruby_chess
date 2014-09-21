class Game
  attr_accessor :current_player, :other_player, :rules, :writer, :board

  def initialize(player1, player2, rules, writer, board)
    self.current_player = player1
    self.other_player   = player2
    self.rules          = rules
    self.writer         = writer
    self.board          = board

    player1.color = :white
    player2.color = :black
  end

  def start
    until rules.game_over?(board)
      next_turn
    end

    show_winner_dialogue
  end

  def next_turn
    writer.show_board board
    move = current_player.get_move

    if rules.valid_move?(move, board, current_player.color)
      board.make_move(move)
      toggle_players
    else
      writer.show "invalid move"
    end
  end

  private

  def toggle_players
    self.current_player, self.other_player = self.other_player, self.current_player
  end

  def show_winner_dialogue
    if rules.winner
      writer.show "#{rules.winner.capitalize} wins."
    else
      writer.show 'Tie game.'
    end
  end
end
