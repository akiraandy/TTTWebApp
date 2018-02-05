require 'spec_helper'
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
      post '/game'
    end

    it "should redirect to welcome if fields not filled" do
      post '/game', params: { game_type: "Test", first_player: "Test" }
      expect(last_response.redirect?).to be true
      follow_redirect!
      expect(last_request.path).to eq('/')
    end

    it "should redirect to game if field are correctly filled" do
      post '/game', params: { game_type: "HvH", first_player: "1" }
      expect(last_response.redirect?).to be true
      follow_redirect!
      expect(last_request.path).to eq('/')
    end
  end

  context "GET /game" do
    before(:each) do
      post '/game', game_type: "HvH", first_player: "1"
      get '/game'
    end

    it "should allow access to the current game if it exists" do
      expect(last_response).to be_ok
    end

    it "should display a tic tac toe board" do
      expect(last_response.body).to include("<table>")
    end
  end

  context 'PUT /game' do
    xit "should update the game state when a move is clicked" do

    end
  end
end

describe 'filling in a space', type: :feature do
  it "should do stuff" do
    post '/game', game_type: "HvH", first_player: "1"
    visit '/game'
    page.find().click
    expect(last_response.redirect?).to be true
  end
end
