require_relative 'board'
require_relative 'player'
require_relative 'ttt_rules'

class Game_Controller
  include TTTRules
  attr_reader :player1, :player2, :row_size
  attr_accessor :board

  def initialize(player1, player2, size = 3)
    @player1 = player1
    @player2 = player2
    @row_size = size
    @board = Board.new(size)
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

  def take_turn(spot = nil)
    turn = active_player.take_turn(game: self, spot: spot)
    if board.valid_spot?(turn.spot)
      board.fill_spot(turn.spot)
      turn.valid = true
    else
      turn.valid = false
    end
    turn
  end
end
