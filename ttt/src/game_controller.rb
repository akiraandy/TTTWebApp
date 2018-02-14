require_relative 'board'
require_relative 'player'

class Game_Controller
  attr_reader :player1, :player2, :active_player_marker, :inactive_player_marker
  attr_accessor :board

  WINNING_COMBOS = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]

  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
    @board = Board.new
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
    board.full? && !winner?
  end

  def active_player
    board.empty_spaces.odd? ? players[0] : players[1]
  end

  def inactive_player
    board.empty_spaces.odd? ? players[1] : players[0]
  end

  def winner
    WINNING_COMBOS.each do |combo|
      if three_in_a_row(combo).uniq.length == 1
        return three_in_a_row(combo)[0]
      end
    end
    nil
  end

  def take_turn(spot = nil)
    turn = active_player.take_turn({game: self, spot: spot})
    if board.valid_spot?(turn.spot)
        board.fill_spot(turn.spot)
        turn
    else
        nil
    end
  end

  def active_player_marker
    active_player.marker
  end

  def inactive_player_marker
    inactive_player.marker
  end
end
