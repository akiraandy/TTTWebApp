require_relative "game_controller"
require_relative "./errors/invalid_range_for_state"

class GameStateManager < Game_Controller 
  attr_accessor :store, :current

  def initialize(player1, player2, size = 3)
    super
    @store = [board.spaces.dup]
    @current = 0
  end

  def take_turn(spot = nil)
    board_reflect_state
    turn = active_player.take_turn({game: self, spot: spot})
    if board.valid_spot?(current_state, turn.spot)
        new_state = board.fill_spot(current_state.dup, turn.spot, turn.marker)
        add_to_store(new_state)
        board_reflect_state
        turn.valid = true
    else
        turn.valid = false
    end
    turn
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
    set_current(last_item_in_store)
  end

  def go_back(steps)
    @current - steps < 0 ? @current = 0 : @current -= steps
    board_reflect_state
  end
  
  def within_state_range(state_index)
    state_index >= 0 && state_index <= last_item_in_store 
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
    last_item_in_store == @current
  end

  def active_player
    if board.spaces.length.odd?
        board.empty_spaces(current_state).odd? ? players[0] : players[1]
    else
        board.empty_spaces(current_state).odd? ? players[1] : players[0]
    end
  end

  def inactive_player
    if board.spaces.length.odd?
        board.empty_spaces(current_state).odd? ? players[1] : players[0]
    else
        board.empty_spaces(current_state).odd? ? players[0] : players[1]
    end
  end
end
