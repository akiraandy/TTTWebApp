class Board
  attr_accessor :spaces

  def initialize
    @spaces = [1, 2, 3, 4, 5, 6, 7, 8, 9]
  end

  def to_s
    " #{@spaces[0]} | #{@spaces[1]} | #{@spaces[2]} \n===+===+===\n #{@spaces[3]} | #{@spaces[4]} | #{@spaces[5]} \n===+===+===\n #{@spaces[6]} | #{@spaces[7]} | #{@spaces[8]} \n"
  end

  def valid_spot?(spaces = @spaces, spot)
    spaces[spot - 1] == spot
  end

  def available_spaces(spaces = @spaces)
    spaces.reject { |space| space.is_a? String }
  end

  def unplayed?(spaces = @spaces)
      available_spaces(spaces).length == spaces.length 
  end

  def last_space
    available_spaces.length == 1 ? available_spaces[0] : nil
  end

  def empty_spaces(spaces = @spaces)
    spaces.count { |space| space.is_a? Integer }
  end

  def fill_spot(spaces = @spaces, spot, marker)
    spaces[spot - 1] = marker
    spaces
  end

  def reset_spot(spot)
    @spaces[spot - 1] = spot
  end

  def full?(spaces = @spaces)
    spaces.all? { |space| space.is_a? String } 
  end
end
