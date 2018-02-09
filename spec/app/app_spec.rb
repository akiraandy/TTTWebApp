require 'spec_helper'
require 'pry-byebug'
require_relative '../../game/game_controller'

describe 'App' do
  context "GET /" do
    it "should allow accessing the welcome page" do
      get "/"
      expect(last_response).to be_ok
    end
  end

  context "POST /game" do
    it "should allow post request" do
      post '/game', {}, { 'rack.session' => { game: Game_Controller.new(Human.new("X", true), Human.new("Y")) } }
      expect(last_response.redirect?).to be true
    end

    it "should redirect to welcome if fields not filled" do
      post '/game', params: { game_type: "Test", first_player: "Test" }
      expect(last_response.redirect?).to be true
      follow_redirect!
      expect(last_request.path).to eq('/')
    end

    it "should redirect to game if field are correctly filled" do
      post '/game', params: { game_type: "HvH", first_player: "first_player" }
      expect(last_response.redirect?).to be true
      follow_redirect!
      expect(last_request.path).to eq('/')
    end

    it "game should start with computer move if computer player going first" do
      post '/game', { game_type: "HvC", first_player: "second_player"}, { 'rack.session' => { game: Game_Controller.new(Human.new("X", false), Computer.new("Y", true)) } }
      expect(last_response.redirect?).to be true
      follow_redirect!
      expect(last_response.body).to include('<td id="Y">Y</td>')
    end
  end

  context "GET /game human versus human" do
    before(:each) do
      get '/game', { }, { 'rack.session' => { game: Game_Controller.new(Human.new("X", false), Human.new("Y", true)) } }
    end

    it "should allow access to the current game if it exists" do
      expect(last_response).to be_ok
    end

    it "should display a tic tac toe board" do
      expect(last_response.body).to include("<table>")
    end

    it "should let the user know who won" do
      game = Game_Controller.new(Human.new("X", true), Human.new("Y"))
      game.board.spaces = ["X", "X", "X", 4, 5, 6, 7, 8, 9]
      get '/game', {}, { 'rack.session' => { game: game } }
      expect(last_response.body).to include('<h1>X won!</h1>')
    end
  end

  context "GET /game computer versus human" do
    before (:each) do
      post '/game', { game_type: "HvC", first_player: "second_player" }, { 'rack.session' => { game: Game_Controller.new(Human.new("X", false), Computer.new("Y", true)) } }
      follow_redirect!
    end

    it "game should start with computer marker on the board if computer goes first" do
      expect(last_response.body).to include('<td id="Y">Y</td>')
    end
  end

  context 'PUT /game' do
    it "should update the game state" do
      get '/game', {}, { 'rack.session' => { game: Game_Controller.new(Human.new("X", true), Human.new("Y")) } }
      put '/game', space: "1"
      get '/game'
      expect(last_response.body).to include('<td id="X">X</td>')
    end

    it "should not update the game state if space is already marked" do
      get '/game', {}, { 'rack.session' => { game: Game_Controller.new(Human.new("X", true), Human.new("Y")) } }
      put '/game', space: "1"
      put '/game', space: "1"
      get '/game'
      expect(last_response.body).to_not include('<td id="Y">Y</td>')
    end

    it "should not update the game state further after the game is over" do
      game = Game_Controller.new(Human.new("X"), Human.new("Y", true))
      game.board.spaces = ["X", "X", "X", "Y", "Y", 6, 7, 8, 9]
      get '/game', {}, { 'rack.session' => { game: game } }
      put '/game', space: "6"
      expect(last_response.redirect?).to be true
      follow_redirect!
      expect(last_response.body).to include('<td id="6">6</td>')
    end
  end
end
