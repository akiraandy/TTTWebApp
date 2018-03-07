# Abstract class for Player
class Player
  Turn = Struct.new(:marker, :spot, :valid)

  attr_reader :marker
  attr_accessor :first, :opponent

  def initialize(marker, first = false)
    @marker = marker
    @first = first
    @opponent = nil
  end
end
