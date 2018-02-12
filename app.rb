require 'sinatra/base'

class WebApp < Sinatra::Base
  enable :sessions
  set :session_secret, "something"

  helpers do
    def get_locale
      I18n.locale
    end

    def t(*args)
      I18n.t(*args)
    end

    def set_locale(locale)
      I18n.locale = locale
    end
  end

  before do
    session[:locale] ? set_locale(session[:locale]) : nil
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

    @board = @game.current_state.each_slice(3).to_a
    erb :game

    if request.xhr?
      redirect "/game"
    else
      erb :game
    end
  end

  post '/game' do
    if !params[:game_type] || !params[:first_player]
      redirect '/'
    end

    case params[:first_player]
    when "first_player"
      first_player = true
      second_player = false
    else
      first_player = false
      second_player = true
    end

    case params[:game_type]
    when "HvH"
      session[:game] = GameStateManager.new(Human.new("X", first_player), Human.new("Y", second_player))
    when "HvC"
      session[:game] = GameStateManager.new(Human.new("X", first_player), Computer.new("Y", second_player))
    end

    game = session[:game]

    if game.active_player.class == Computer
      game.take_turn
    end

    redirect '/game'
  end

  post '/locale' do
    session[:locale] = params[:locale]
    redirect "/"
  end

  put '/game' do
    spot = params[:space].to_i
    game = session[:game]

    if game.over?
      redirect '/game'
    end

    moves = []
    turn = game.take_turn(spot)
    moves << { marker: turn.marker, spot: turn.spot }
    if game.active_player.class == Computer && !game.over?
      turn = game.take_turn
      moves << { marker: turn.marker, spot: turn.spot }
    end

    if request.xhr?
      JSON.generate(moves: moves, winner: game.winner, tie: game.tie?, over: game.over?, back: (t 'back', get_locale), win_locale: (t 'won', get_locale), tie_locale: (t 'tie', get_locale))
    else
      redirect '/game'
    end
  end
end
