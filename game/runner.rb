require_relative 'setup'
require_relative 'game_controller'
require_relative 'human'
require_relative 'computer'

GAME_TYPES = ["HvH", "HvC", "CvC"]

input = ""
while !input.match(/\Aexit\z/i)

  setup = Setup.new

  case GAME_TYPES[setup.game_type]
  when "HvH"
    game = Game_Controller.new(Human.new(setup.player1[:marker], setup.player1[:start]), Human.new(setup.player2[:marker], setup.player2[:start]))
    game.play
  when "HvC"
    game = Game_Controller.new(Human.new(setup.player1[:marker], setup.player1[:start]), Computer.new(setup.player2[:marker], setup.player2[:start]))
    game.play
  when "CvC"
    game = Game_Controller.new(Computer.new(setup.player1[:marker], setup.player1[:start]), Computer.new(setup.player2[:marker], setup.player2[:start]), 1)
    game.play
  else
    puts "Invalid game type"
    input = "exit"
  end

  puts "\nPlay again? Enter any key to continue, otherwise enter 'exit'"
  input = gets.chomp
end
