require_relative 'player'

class Computer < Player
  attr_accessor :game
  attr_reader :best_move

  def initialize(marker, first=false)
    super
  end

  def take_corner
    corners = [1, 3, 7, 9]
    @game.board.available_spaces.select { |space| corners.include?(space) }.sample
  end

  def take_turn(game)
    @game = game
    game.board.fill_spot(choose_move, marker)
    @best_move
  end

  def choose_move
    return take_corner if game.board.unplayed?
    return game.board.last_space if game.board.last_space
    best_possible_move
    @best_move
  end

  def score(game, last_move_marker)
    return 0 if game.tie?
    return 10 if last_move_marker == marker
    return -10 if last_move_marker == @opponent.marker
  end

  def best_possible_move(game=@game, last_move_marker=@opponent.marker)
    scores =[]
    moves =[]
    current_marker = nil
    return score(game, last_move_marker) if game.over?

    game.board.available_spaces.each do |space|
      current_marker = next_player_marker(last_move_marker)
      game.board.fill_spot(space, current_marker)
      scores.push best_possible_move(game, current_marker)
      moves.push space
      game.board.reset_spot(space)
    end

    if current_marker == marker
      max_score_index = scores.each_with_index.max[1]
      @best_move = moves[max_score_index]
      return scores.max
    else
      min_score_index = scores.each_with_index.min[1]
      @best_move = moves[min_score_index]
      return scores.min
    end
  end

  def next_player_marker(last_move_marker)
    if last_move_marker == @opponent.marker
      marker
    else
      @opponent.marker
    end
  end
end
