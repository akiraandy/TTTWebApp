require_relative 'player'

# Human inherits from player. Take_turn returns a new Turn object.
class Human < Player
  def initialize(marker, first = false)
    super
  end

  def take_turn(args)
    Turn.new(marker, args[:spot])
  end
end
