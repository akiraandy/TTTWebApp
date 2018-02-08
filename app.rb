require 'sinatra'
require 'json'
require_relative './game/game_controller'
require_relative './game/human'
require_relative './game/computer'
require 'pry-byebug'
enable :sessions
set :session_secret, "something"

get '/' do
  erb :welcome
end

get '/game' do
  game = session[:game]
  if game
    @board = game.board.spaces.each_slice(3).to_a
    @game = game
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
  when "first_player"
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
  if game.over?
    redirect '/game'
  end

  if game.active_player.class == Computer
    marker = game.active_player.marker
    spot = game.active_player.take_turn(game)
  else
    marker = game.active_player.marker
    valid_move = game.active_player.take_turn(game, spot)
  end

  if request.xhr?
    JSON.generate(marker: marker, spot: spot, valid: valid_move, winner: game.winner, tie: game.tie?, computer: game.active_player.class)
  else
    redirect '/game'
  end
end
