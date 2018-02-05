class Setup

  attr_reader :player1, :player2, :game_type

  def initialize
    @player1 = { marker: nil }
    @player2 = { marker: nil }
    intro
    ask_for_game_type
    get_player_settings
  end

  def ask_for_game_type
    puts "\nPlease enter which type of game you would like to play: "
    puts "1: Human vs. Human \n2: Human vs. Computer \n3: Computer vs. Computer"
    get_game_type
  end

  def recap_player_settings
    if @player1[:marker] && @player2[:marker]
      puts "\nPlayer #1's character is: \"#{@player1[:marker]}\""
      puts "Player #2's character is: \"#{@player2[:marker]}\""
    end
  end

  def get_game_type
    input = gets.chomp
    if valid_game_type?(input)
      @game_type = input.to_i - 1
    else
      puts "\nInvalid input."
      ask_for_game_type
    end
  end

  def valid_game_type?(input)
    /\A[123]\z/ === input
  end

  def intro
    puts "\nWelcome to Tic Tac Toe!"
  end

  def get_player_settings
    2.times { |num| ask_for_player_marker(num + 1) }
    recap_player_settings
    ask_for_first_player
  end

  def player_going_first
    first_player = [@player1, @player2].sort_by { |player| player.first ? 0 : 1 }[0]
    first_player == @player1 ? 1 : 2
  end

  def valid_marker?(input)
    /\A[A-Z]\z/i === input && unique_marker?(input)
  end

  def unique_marker?(marker)
    @player1[:marker] != marker.capitalize
  end

  def valid_first_player?(input)
    /\A[12]\z/ === input
  end

  def ask_for_player_marker(player_num)
    puts "\nSelect player ##{player_num}'s character"
    puts "Please enter a letter A to Z: "
    get_player_marker(player_num)
  end

  def get_player_marker(player_num)
    marker = gets.chomp
    if valid_marker?(marker) && player_num == 1
      @player1[:marker] = marker.capitalize
    elsif valid_marker?(marker) && player_num == 2
      @player2[:marker] = marker.capitalize
    else
      puts "\nInvalid player character"
      ask_for_player_marker(player_num)
    end
  end

  def ask_for_first_player
    puts "\nWho should go first?"
    puts "Please enter 1 for player#1 or 2 for player#2"
    get_first_player
  end

  def get_first_player
    input = gets.chomp
    if valid_first_player?(input) && input.to_i == 1
      @player1[:start], @player2[:start] = true, false
    elsif valid_first_player?(input) && input.to_i == 2
      @player1[:start], @player2[:start] = false, true
    else
      puts "\nInvalid input"
      ask_for_first_player
    end
  end
end
