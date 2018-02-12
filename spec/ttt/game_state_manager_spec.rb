require_relative '../../ttt/src/game_state_manager'
require_relative '../../ttt/src/human'

RSpec.describe GameStateManager do

  let(:player1) { Human.new("X") }
  let(:player2) { Human.new("Y") }
  let(:game) { GameStateManager.new(player1, player2)}

  it "should be initialized with two players" do
    expect{ GameStateManager.new(player1, player2) }.not_to raise_error
  end

  it "should be initialized with a current property" do
    expect{game.current}.not_to raise_error
  end

  it "should have a board attribute" do
    expect(game.board).to be_a Board
  end

  it "should have a store attribute that starts with a state object" do
    expect(game.store.length).to eq 1
  end

  context "#add_to_store" do
    it "should add state to the store" do
      game.add_to_store(Array.new(0))
      expect(game.store.length).to be 2
    end

    it "should delete all states ahead of the current one being added" do
      game.store = ["a", "b", "c", "d"]
      game.current = 0
      game.add_to_store("e")
      expect(game.store).to eq ["a", "e"]
    end

    it "should set the current state to the one just added" do
      game.store = ["a", "b", "c", "d"]
      game.current = 0
      game.add_to_store("e")
      expect(game.current).to eq 1
    end
  end

  context "#remove_from_store" do
    before(:each) do
      game.store = ["a", "b", "c"]
    end

    it "should remove last state from store" do
      game.remove_from_store
      expect(game.store).to eq ["a", "b"]
    end
  end

  context "#set_current" do
    before(:each) do
      game.store = ["a", "b", "c"]
    end

    it "should set state and return the current state" do
      expect(game.current).to eq 0
      expect(game.set_current(1)).to eq 1
      expect(game.current).to eq 1
    end

    it "should not be able to go less than 0" do
      expect{ game.set_current(-1) }.to raise_error InvalidRangeForState
    end
  end

  context "#go_back" do
    before(:each) do
      game.store = ["a", "b", "c", "d", "e"]
    end

    it "should set the current state position X steps back" do
      game.current = 4
      game.go_back(3)
      expect(game.current).to eq 1
    end

    it "should set the current state position to the first state if too many steps are made" do
      game.current = 4
      game.go_back(15)
      expect(game.current).to eq 0
    end
  end

  context "#current_state" do
    before(:each) do
      game.current = 1
      game.store = ["a", "b", "c"]
    end

    it "should return whatever is at the current state position" do
      expect(game.current_state).to eq "b"
    end
  end
end
