require_relative 'game_controller'
require_relative './errors/invalid_range_for_state'
# Extends GameControllerClass to include state functionality.
class GameStateManager < GameController
  attr_accessor :store, :current

  def initialize(player1, player2, size = 3)
    super
    @store = [board.spaces.dup]
    @current = 0
  end

  def take_turn(spot = nil)
    board_reflect_state
    turn = active_player.take_turn(game: self, spot: spot)
    if board.valid_spot?(turn.spot, current_state)
      handle_state(current_state, turn)
      turn.valid = true
    else
      turn.valid = false
    end
    turn
  end

  def handle_state(current_state, turn)
    new_state = board.fill_spot(turn.spot, turn.marker, current_state.dup)
    add_to_store(new_state)
    board_reflect_state
  end

  def current_state
    store[current]
  end

  def last_item_in_store
    @store.length - 1
  end

  def board_reflect_state
    board.spaces = current_state
  end

  def add_to_store(state)
    remove_from_store until current_at_last_position?
    @store << state
    adjust_current_state(last_item_in_store)
  end

  def go_back(steps)
    @current - steps < 0 ? @current = 0 : @current -= steps
    board_reflect_state
  end

  def within_state_range(state_index)
    state_index >= 0 && state_index <= last_item_in_store
  end

  def adjust_current_state(state_index)
    raise InvalidRangeForState unless within_state_range(state_index)
    @current = state_index
  end

  def remove_from_store
    @store.pop
  end

  def current_at_last_position?
    last_item_in_store == @current
  end

  def active_player
    if board.spaces.length.odd?
      odd_active_board_turn_order
    else
      even_active_board_turn_order
    end
  end

  def odd_active_board_turn_order
    board.empty_spaces(current_state).odd? ? players[0] : players[1]
  end

  def even_active_board_turn_order
    board.empty_spaces(current_state).even? ? players[0] : players[1]
  end

  def odd_inactive_board_turn_order
    board.empty_spaces(current_state).odd? ? players[1] : players[0]
  end

  def even_inactive_board_turn_order
    board.empty_spaces(current_state).even? ? players[1] : players[0]
  end

  def inactive_player
    if board.spaces.length.odd?
      odd_inactive_board_turn_order
    else
      even_inactive_board_turn_order
    end
  end
end
