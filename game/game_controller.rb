require_relative 'board'
require_relative 'player'

class Game_Controller
  attr_reader :player1, :player2, :active_player_marker, :inactive_player_marker
  attr_accessor :active_player, :inactive_player, :board

  WINNING_COMBOS = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]

  def initialize(player1, player2, slow=0)
    @player1 = player1
    @player2 = player2
    @last_move = nil
    @board = Board.new
    @slow = slow
    assign_opponents
  end

  def assign_opponents
    @player1.opponent = @player2
    @player2.opponent = @player1
  end

  # an array of the game's players sorted by turn order
  def players
    [@player1, @player2].sort_by { |player| player.first ? 0 : 1 }
  end

  def winner?
    WINNING_COMBOS.each do |combo|
      return true if three_in_a_row(combo).uniq.length == 1
    end
    false
  end

  def over?
    winner? || tie?
  end

  # takes in a combination of winning spaces and matches those indexes to the current board
  def three_in_a_row(combo)
    [@board.spaces[combo[0]], @board.spaces[combo[1]], @board.spaces[combo[2]]]
  end

  def tie?
    board.spaces.all? { |space| space.is_a? String } && !winner?
  end

  def active_player
    if board.empty_spaces.odd?
      players[0]
    else
      players[1]
    end
  end

  def inactive_player
    if board.empty_spaces.odd?
      players[1]
    else
      players[0]
    end
  end

  def winner
    WINNING_COMBOS.each do |combo|
      if three_in_a_row(combo).uniq.length == 1
        return three_in_a_row(combo)[0]
      end
    end
    nil
  end

  def announce_last_move
    if board.last_move
      puts "\n#{board.last_move[:marker]} chose spot #{board.last_move[:spot]}"
    end
  end

  def display
    puts `clear`
    puts board.to_s
    announce_last_move
  end

  def take_turns
    players.each do |player|
      # display
      player.take_turn(self)
      # sleep(@slow)
      break if over?
    end
  end

  def play
    until over?
      take_turns
    end
    game_end
  end

  def game_type
    if players.all? { |player| player.class == Human }
      "HvH"
    elsif players.all? { |player| player.class == Computer }
      "CvC"
    else
      "HvC"
    end
  end

  def game_end
    display
    if winner?
      puts "\nGame over! #{winner} won!"
    else
      puts "\nGame over! It's a tie!"
    end
  end
end
