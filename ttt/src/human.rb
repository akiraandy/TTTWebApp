require_relative 'player'

class Human < Player

  def initialize(marker, first=false)
    super
  end

  def take_turn(args)
      Turn.new(marker, args[:spot])
  end

end
