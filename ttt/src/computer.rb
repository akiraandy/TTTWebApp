require_relative 'player'
require 'pry-byebug'
class Computer < Player
  attr_accessor :game
  attr_reader :best_move

  def initialize(marker, first=false)
    super
  end

  def take_corner
    game.board.corners.sample
  end

  def take_turn(args)
    @game = args[:game]
    Turn.new(marker, choose_move)
  end

  def choose_move
    @best_move = {}
    return take_corner if game.board.unplayed?
    negamax(game)
    @best_move.max_by { |key, value| value }[0]
  end

  def score(game, depth)
    return 0 if game.tie?
    return 1000 / depth if game.winner == marker
    return -1000 / depth
  end

  def negamax(game, depth = 0, alpha = -1000, beta = 1000, color = 1)
    return color * score(game, depth) if game.over?

    max = -1000

    game.board.available_spaces.each do |space|
      game.board.fill_spot(space, game.active_player.marker)
      negamax_value = -negamax(game, depth+1, -beta, -alpha, -color)
      game.board.reset_spot(space)

      max = [max, negamax_value].max
      @best_move[space] = max if depth == 0
      alpha = [alpha, negamax_value].max
      return alpha if alpha >= beta
    end

    max
  end
end
