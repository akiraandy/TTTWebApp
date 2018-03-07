require_relative 'player'
# Computer inherits from player. Take_turn returns new move. Best_possible_move implements negamax algorithm
class Computer < Player
  attr_accessor :game
  attr_reader :best_move

  def initialize(marker, first = false)
    super
  end

  def take_turn(args)
    @game = args[:game]
    Turn.new(marker, choose_move)
  end

  def take_corner
    game.board.corners.sample
  end

  def choose_move
    @best_move = {}
    return take_corner if game.board.unplayed?
    best_possible_move(game)
    @best_move.max_by { |_key, value| value }[0]
  end

  def score(game, depth)
    return 0 if game.tie?
    return 1000 / depth if game.winner == marker
    -1000 / depth
  end

  def best_possible_move(game, last_move_marker = @opponent.marker, depth = 0, alpha = -1000, beta = 1000, color = 1, max_depth = 6)
    current_marker = nil
    return color * score(game, depth) if game.over? || depth > max_depth
    max = -1000
    game.board.available_spaces.each do |space|
      current_marker = next_player_marker(last_move_marker)
      game.board.fill_spot(space, current_marker)
      negamax_value = -best_possible_move(game, current_marker, depth + 1, -beta, -alpha, -color)
      game.board.reset_spot(space)
      max = [max, negamax_value].max
      @best_move[space] = max if depth.zero?
      alpha = [alpha, negamax_value].max
      return alpha if alpha >= beta
    end
    max
  end

  def next_player_marker(last_move_marker)
    last_move_marker == @opponent.marker ? marker : @opponent.marker
  end
end
