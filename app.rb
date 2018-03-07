require 'sinatra/base'
# Main sinatra app with routes and I18n integration
class WebApp < Sinatra::Base
  enable :sessions
  set :session_secret, 'something'

  helpers do
    def locale_get
      I18n.locale
    end

    def t(*args)
      I18n.t(*args)
    end

    def locale_set(locale)
      I18n.locale = locale
    end
  end

  before do
    session[:locale] ? locale_set(session[:locale]) : nil
  end

  get '/' do
    erb :welcome
  end

  get '/game' do
    if session[:game]
      @game = session[:game]
    else
      redirect '/'
    end
    @board = @game.current_state.each_slice(@game.board.row_size).to_a
    erb :game
  end

  post '/game' do
    if !params[:game_type] || !params[:first_player]
      @error = t 'error', locale_get
      erb :welcome
    else
      case params[:first_player]
      when 'PLAYER_ONE'
        first_player = true
        second_player = false
      else
        first_player = false
        second_player = true
      end

      size = case params[:board_size]
             when '4'
               4
             else
               3
             end

      case params[:game_type]
      when 'HvH'
        session[:game] = GameStateManager.new(Human.new('X', first_player), Human.new('Y', second_player), size)
      when 'HvC'
        session[:game] = GameStateManager.new(Human.new('X', first_player), Computer.new('Y', second_player), size)
      end

      game = session[:game]

      game.take_turn if game.active_player.class == Computer

      redirect '/game'
    end
  end

  post '/locale' do
    session[:locale] = params[:locale]
    redirect '/'
  end

  put '/rewind' do
    game = session[:game]
    redirect '/' if game.board.unplayed?(game.current_state)
    if game.inactive_player.class == Computer
      game.go_back(2)
    else
      game.go_back(1)
    end

    JSON.generate(succes: 'SUCCESS')
  end

  get '/playAgain' do
    if session[:game]
      game = session[:game]
      game = GameStateManager.new(game.player1, game.player2, game.row_size)
      game.take_turn if game.active_player.class == Computer
      session[:game] = game
      redirect '/game'
    else
      redirect '/'
    end
  end

  put '/game' do
    spot = params[:space].to_i
    game = session[:game]

    redirect '/game' if game.over?

    moves = []
    turn = game.take_turn(spot)
    moves << { marker: turn.marker, spot: turn.spot } if turn.valid

    if game.active_player.class == Computer && !game.over?
      turn = game.take_turn
      moves << { marker: turn.marker, spot: turn.spot }
    end

    if request.xhr?
      JSON.generate(moves: moves, winner: game.winner, tie: game.tie?, over: game.over?, back: (t 'back', locale_get), win_locale: (t 'won', locale_get), tie_locale: (t 'tie', locale_get))
    else
      redirect '/game'
    end
  end
end
