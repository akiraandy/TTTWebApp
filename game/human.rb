require_relative 'player'

class Human < Player

  def initialize(marker, first=false)
    super
  end

  def display_for_turn(game)
    announce_turn
    puts "\nPlease choose an empty space on the board, 1 through #{game.board.spaces.length}: "
  end

  def take_turn(game)
    display_for_turn(game)
    spot = $stdin.gets.chomp.to_i
    if game.board.valid_spot?(spot)
      game.board.fill_spot(spot, marker)
    else
      puts "Invalid input."
      take_turn(game)
    end
  end

end
