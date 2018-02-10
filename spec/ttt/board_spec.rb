require_relative '../../ttt/src/board'
require_relative '../../ttt/src/player'

RSpec.describe Board do
  let(:board) { Board.new }
  context "#spaces" do

    it "should be an array of strings from 1 to 9" do
      expect(board.spaces).to eq([1, 2, 3, 4, 5, 6, 7, 8, 9])
    end
  end

  context "#to_s" do
    it "should return a string" do
      expect(board.to_s).to eq(" #{board.spaces[0]} | #{board.spaces[1]} | #{board.spaces[2]} \n===+===+===\n #{board.spaces[3]} | #{board.spaces[4]} | #{board.spaces[5]} \n===+===+===\n #{board.spaces[6]} | #{board.spaces[7]} | #{board.spaces[8]} \n")
    end
  end

  context '#valid_spot?' do
    it "should return false if spot is taken" do
      board.spaces[0] = "X"
      expect(board.valid_spot?(0)).to eq(false)
    end

    it "should return true if the spot is not taken" do
      expect(board.valid_spot?(1)).to eq(true)
    end
  end

  context "#available_spaces" do
    it "should return a board with available spaces" do
      board.spaces = ["X", 1, "O", 3, "X", 5, "O", 7, "X"]
      expect(board.available_spaces).to eq([1, 3, 5, 7])
      board.spaces = ["X", 1, 2, 3, 4, 5, "O", 7, 8]
      expect(board.available_spaces).to eq([1,2,3,4,5,7,8])
    end

    it "should return an empty array if there are no available spaces" do
      board.spaces = ["X", "X", "X", "X", "X", "X", "X", "X", "X"]
      expect(board.available_spaces).to eq([])
    end
  end

  context "#fill_spot" do
    let(:player1) { Player.new("X") }
    it "should fill a space with the specified marker" do
      board.fill_spot(1, player1.marker)
      expect(board.spaces[0]).to eq("X")
    end
  end
end
