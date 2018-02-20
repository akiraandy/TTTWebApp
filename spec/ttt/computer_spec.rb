require_relative '../../ttt/src/computer'
require_relative '../../ttt/src/board'
require_relative '../../ttt/src/human'
require_relative '../../ttt/src/game_controller'

RSpec.describe Computer do
  let(:computer) { Computer.new("X", true) }
  let(:other_player) { Computer.new("O") }
  let(:game) { Game_Controller.new(computer, other_player) }

  it "inherits marker from parent class" do
    expect(computer.marker).to eq("X")
  end

  context "#best_possible_move" do
    it "returns an index if there is a spot on the board that would win them the game" do
      game.board.spaces = ["O", "X", "O", 4, "X", 6, 7, 8, "O"]
      computer.best_possible_move(game)
      expect(computer.best_move).to eq(8)
      game.board.spaces = ["O", "X", "O", "X", "X", "O", 7, 8, 9]
      computer.best_possible_move(game)
      expect(computer.best_move).to eq(8)
      game.board.spaces = ["X", 2, "O", 4, "X", "O", 7, 8, 9]
      computer.best_possible_move(game)
      expect(computer.best_move).to eq(9)
      game.board.spaces = ["X", 2, "O", 4, "X", "O", 7, 8, 9]
      computer.best_possible_move(game)
      expect(computer.best_move).to eq(9)
      game.board.spaces = ["O", "O", "X", "O", "X", "O", 7, "O", "X"]
      computer.best_possible_move(game)
      expect(computer.best_move).to eq(7)
      game.board.spaces = ["O", "O", "X", "O", "X", 6, 7, 8, 9]
      computer.best_possible_move(game)
      expect(computer.best_move).to eq(7)
      game.board.spaces = ["X", "O", "O", 4, "X", 6, 7, "O", 9]
      computer.best_possible_move(game)
      expect(computer.best_move).to eq(9)
      game.board.spaces = ["O", "X", 3, 4, "X", 6, "O", 8, 9]
      computer.best_possible_move(game)
      expect(computer.best_move).to eq(8)
      game.board.spaces = ["X", "O", "O", 4, "X", 6, "O", 8, 9]
      computer.best_possible_move(game)
      expect(computer.best_move).to eq(9)
    end

    it "puts a marker down in a spot if placing the opponent's marker there would win them the game" do
      game.board.spaces = ["O", 2, "X", "X", "O", 6, 7, 8, 9]
      computer.best_possible_move(game)
      expect(computer.best_move).to eq(9)
      game.board.spaces = [1, 2, "X", "X", "O", 6, 7, "O", 9]
      computer.best_possible_move(game)
      expect(computer.best_move).to eq(2)
      game.board.spaces = ["X", "X", "O", 4, "O", 6, 7, 8, 9]
      computer.best_possible_move(game)
      expect(computer.best_move).to eq(7)
    end
  end

  context "#take_corner" do
    it "takes a corner if it is available" do
      game.board.spaces = ["O", 2, "O", 4, 5, 6, 7, 8, "X"]
      computer.game = game
      expect(computer.take_corner).to eq(7)
    end

    it "returns nil if no corner spaces are available" do
      game.board.spaces = ["O", 2, "X", 4, 5, 6, "X", 8, "O"]
      computer.game = game
      expect(computer.take_corner).to eq(nil)
    end
  end

  context "#choose_move" do
    it "chooses a corner if it is the first turn of the game" do
      game.board.spaces = [1, 2, 3, 4, 5, 6, 7, 8, 9]
      computer.game = game
      expect([1, 3, 7, 9]).to include(computer.choose_move)
    end

    it "chooses the last space without running best_possible_move" do
      game.board.spaces = ["O", "O", "X", "X", "O", 6, "X", "X", "O"]
      computer.game = game
      expect(computer).to_not receive(:best_possible_move)
      computer.choose_move
    end

    it "chooses the best possible move if necessary" do
      game.board.spaces = ["O", 2, 3, 4, "X", 6, 7, 8, 9]
      computer.game = game
      expect(computer).to receive(:best_possible_move)
      computer.choose_move
    end
  end
end
