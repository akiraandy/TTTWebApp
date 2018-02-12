require_relative 'player'

class Human < Player

  def initialize(marker, first=false)
    super
  end

  def take_turn(game, spot)
     game.board.fill_spot(spot, marker)
  end

end
