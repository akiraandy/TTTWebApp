require_relative "game_controller"
require_relative "invalidRangeForState"

class GameStateManager < Game_Controller
  attr_accessor :store, :current

  def initialize(player1, player2)
    super
    @store = [@board.spaces]
    @current = 0
  end

  def take_turn(spot = nil, game = self)
    valid = active_player.take_turn(game, spot)
    valid ? add_to_store(board.spaces) : nil
    valid
  end

  def current_state
    store[current]
  end

  def add_to_store(state)
    remove_from_store until current_at_last_position?
    @store << state
    set_current(@store.length - 1)
  end

  def go_back(steps)
    @current - steps < 0 ? @current = 0 : @current -= steps
  end

  def within_state_range(state_index)
    state_index >= 0 && state_index <= @store.length - 1
  end

  def set_current(state_index)
    if within_state_range(state_index)
      @current = state_index
    else
      raise InvalidRangeForState
    end
  end

  def remove_from_store
    @store.pop
  end

  def current_at_last_position?
    @store.length - 1 == @current
  end
end
