class Player
  attr_reader :marker
  attr_accessor :first, :opponent

  def initialize(marker, first=false)
    @marker = marker
    @first = first
    @opponent = nil
  end

  def announce_turn
    puts "\n#{marker}'s turn!"
  end

  def announce_move(spot)
    puts "\n#{marker} chose spot #{spot}."
  end

end
