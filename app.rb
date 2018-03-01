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
    @board = @game.current_state.each_slice(@game.board.row_size).to_a
    erb :game
  end

  post '/game' do
    if !params[:game_type] || !params[:first_player]
        @error = t "error", get_locale 
        erb :welcome
    else
        case params[:first_player]
        when "PLAYER_ONE"
          first_player = true
          second_player = false
        else
          first_player = false
          second_player = true
        end

        case params[:board_size]
        when "4"
            size = 4
        else
            size = 3
        end

        case params[:game_type]
        when "HvH"
          session[:game] = GameStateManager.new(Human.new("X", first_player), Human.new("Y", second_player), size)
        when "HvC"
          session[:game] = GameStateManager.new(Human.new("X", first_player), Computer.new("Y", second_player), size)
        end

        game = session[:game]

        if game.active_player.class == Computer
          game.take_turn
        end

        redirect '/game'
    end
  end

  post '/locale' do
    session[:locale] = params[:locale]
    redirect "/"
  end

  put '/rewind' do
    game = session[:game]
    if game.board.unplayed?(game.current_state)
        redirect "/"
    end
    if game.inactive_player.class == Computer
        game.go_back(2)
    else
        game.go_back(1)
    end
    
    JSON.generate(succes: "SUCCESS")
  end

  get '/playAgain' do
      if session[:game]
        game = session[:game]
        game = GameStateManager.new(game.player1, game.player2)
        if game.active_player.class == Computer
            game.take_turn
        end
        session[:game] = game
        redirect '/game'
      else
          redirect '/'
      end
  end

  put '/game' do
    spot = params[:space].to_i
    game = session[:game]

    if game.over?
      redirect '/game'
    end

    moves = []
    turn = game.take_turn(spot)
    if turn.valid
        moves << { marker: turn.marker, spot: turn.spot }
    end

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
