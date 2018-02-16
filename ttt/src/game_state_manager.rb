require_relative "game_controller"
require_relative "./errors/invalidRangeForState"

class GameStateManager < Game_Controller 
  attr_accessor :store, :current

  def initialize(player1, player2)
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
        turn.valid = true
    else
        turn.valid = false
    end
    turn
  end

  def current_state
    store[current]
  end

  def board_reflect_state
      board.spaces = current_state
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

  def active_player
    board.empty_spaces(current_state).odd? ? players[0] : players[1]
  end

  def inactive_player
    board.empty_spaces(current_state).odd? ? players[1] : players[0]
  end
      
  def three_in_a_row(combo)
    [current_state[combo[0]], current_state[combo[1]], current_state[combo[2]]]
  end
  
  def tie?
    board.full?(current_state) && !winner?
  end
end