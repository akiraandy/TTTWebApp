require 'sinatra'
require 'json'
require_relative './game/game_controller'
require_relative './game/human'
require_relative './game/computer'

enable :sessions
set :session_secret, "something"

get '/' do
  erb :welcome
end

get '/game' do
  game = session[:game]
  if game
    @board = game.board.spaces.each_slice(3).to_a
    erb :game
  else
    redirect '/'
  end
end

post '/game' do
  if !params[:game_type] || !params[:first_player]
    redirect '/'
  end

  case params[:first_player]
  when 1
    first_player = true
    second_player = false
  else
    first_player = false
    second_player = true
  end

  case params[:game_type]
  when "HvH"
    session[:game] = Game_Controller.new(Human.new("X", first_player), Human.new("Y", second_player))
  when "HvC"
    session[:game] = Game_Controller.new(Human.new("X", first_player), Computer.new("Y", second_player))
  when "CvC"
    session[:game] = Game_Controller.new(Computer.new("X", first_player), Computer.new("Y", second_player))
  end

  redirect '/game'
end

put '/game' do
  spot = params[:space].to_i
  game = session[:game]
  if game.active_player == Computer
    game.active_player.take_turn(game)
  else
    game.active_player.take_turn(game, spot)
  end

  if request.xhr?
    JSON.generate(marker: game.active_player.marker, spot: spot)
  else
    redirect '/game'
  end
end
