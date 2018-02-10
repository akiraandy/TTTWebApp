require_relative 'player'

class Human < Player

  def initialize(marker, first=false)
    super
  end

  def display_for_turn(game)
    announce_turn
    puts "\nPlease choose an empty space on the board, 1 through #{game.board.spaces.length}: "
  end

  def take_turn(game, spot)
    if game.board.valid_spot?(spot)
      game.board.fill_spot(spot, marker)
      true
    else
      false
    end
  end

end
