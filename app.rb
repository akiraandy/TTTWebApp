require 'sinatra'
Dir["./ttt/src/*.rb"].each {|file| require file }

enable :sessions
set :session_secret, "something"

get '/' do
  erb :welcome
end

get '/game' do
  if session[:game]
    @game = session[:game]
  else
    redirect '/'
  end

  @board = @game.board.spaces.each_slice(3).to_a
  erb :game
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
  end

  game = session[:game]

  if game.active_player.class == Computer
    game.active_player.take_turn(game)
  end

  redirect '/game'
end

put '/game' do
  spot = params[:space].to_i
  game = session[:game]

  if game.over?
    redirect '/game'
  end

  moves = []
  moves << { marker: game.active_player.marker, valid: game.active_player.take_turn(game, spot), spot: spot }
  if game.active_player.class == Computer && !game.over?
    game.active_player.take_turn(game)
    moves << { marker: game.inactive_player.marker, valid: true, spot: game.inactive_player.best_move }
  end

  if request.xhr?
    JSON.generate(moves: moves, winner: game.winner, tie: game.tie?, over: game.over?)
  else
    redirect '/game'
  end
end
