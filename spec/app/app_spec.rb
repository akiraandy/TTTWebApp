require File.expand_path '../../spec_helper.rb', __FILE__
require_relative '../../ttt/src/game_state_manager'
require_relative '../../ttt/src/human'
require_relative '../../ttt/src/computer'

describe WebApp do
  context 'GET /' do
    it 'allows accessing the welcome page' do
      get '/'
      expect(last_response).to be_ok
    end
  end

  context 'POST /game' do
    it 'allows post request' do
      post '/game', { game_type: 'Test', first_player: 'Test' }, 'rack.session' => { game: GameStateManager.new(Human.new('X', true), Human.new('Y')) }
      expect(last_response.redirect?).to be true
    end

    it 'shows error on welcome if fields not filled' do
      post '/game'
      expect(last_response.body).to include('<h3 data-id="error">')
    end

    it 'redirects to game if fields are correctly filled' do
      post '/game', game_type: 'HvH', first_player: 'first_player'
      expect(last_response.redirect?).to be true
      follow_redirect!
      expect(last_request.path).to eq('/game')
    end

    it 'starts with computer move if computer player going first' do
      post '/game', { game_type: 'HvC', first_player: 'second_player' }, 'rack.session' => { game: GameStateManager.new(Human.new('X', false), Computer.new('Y', true)) }
      expect(last_response.redirect?).to be true
      follow_redirect!
      expect(last_response.body).to include('<td data-cell="cell" data-id="Y">Y</td>')
    end
  end

  context 'GET /game human versus human' do
    before(:each) do
      get '/game', {}, 'rack.session' => { game: GameStateManager.new(Human.new('X', false), Human.new('Y', true)) }
    end

    it 'allow access to the current game if it exists' do
      expect(last_response).to be_ok
    end

    it 'displays a tic tac toe board' do
      expect(last_response.body).to include('<table>')
    end

    it 'lets the user know who won' do
      game = GameStateManager.new(Human.new('X', true), Human.new('Y'))
      game.store = [['X', 'X', 3, 4, 5, 6, 7, 8, 9]]
      game.take_turn(3)
      get '/game', {}, 'rack.session' => { game: game }
      expect(last_response.body).to include('<h1>X won!</h1>')
    end
  end

  context 'GET /game computer versus human' do
    before(:each) do
      post '/game', { game_type: 'HvC', first_player: 'second_player' }, 'rack.session' => { game: GameStateManager.new(Human.new('X', false), Computer.new('Y', true)) }
      follow_redirect!
    end

    it 'game starts with computer marker on the board if computer goes first' do
      expect(last_response.body).to include('<td data-cell="cell" data-id="Y">Y</td>')
    end
  end

  context 'PUT /game' do
    it 'updates the game state' do
      get '/game', {}, 'rack.session' => { game: GameStateManager.new(Human.new('X', true), Human.new('Y')) }
      put '/game', space: '1'
      get '/game'
      expect(last_response.body).to include('<td data-cell="cell" data-id="X">X</td>')
    end

    it 'does not update the game state if space is already marked' do
      get '/game', {}, 'rack.session' => { game: GameStateManager.new(Human.new('X', true), Human.new('Y')) }
      put '/game', space: '1'
      put '/game', space: '1'
      get '/game'
      expect(last_response.body).to_not include('<td data-cell="cell" data-id="Y">Y</td>')
    end

    it 'does not update the game state further after the game is over' do
      game = GameStateManager.new(Human.new('X', true), Human.new('Y'))
      game.store = [['X', 'X', 3, 'Y', 'Y', 6, 7, 8, 9]]
      get '/game', {}, 'rack.session' => { game: game }
      put '/game', space: '3'
      expect(last_response.redirect?).to be true
      follow_redirect!
      put '/game', space: '6'
      expect(last_response.redirect?).to be true
      follow_redirect!
      expect(last_response.body).to include('<td data-cell="cell" data-id="6"></td>')
    end
  end

  context 'POST /locale' do
    before(:each) do
      post '/locale', locale: 'ja'
    end

    it 'allows post request' do
      expect(last_response.redirect?).to be true
    end

    it 'changes the language' do
      follow_redirect!
      expect(last_response.body).to include('<h1>三目並べ</h1>')
    end
  end

  context 'GET /playAgain' do
    it 'creates a new game using same settings of last game' do
      game = GameStateManager.new(Human.new('X', true), Human.new('Y'))
      game.store = [%w[X Y X X X Y X Y Y]]
      get '/game', {}, 'rack.session' => { game: game }
      get '/playAgain'
      follow_redirect!
      expect(last_response.body).to include('<td data-cell="cell" data-id="6"></td>')
    end
  end
end
