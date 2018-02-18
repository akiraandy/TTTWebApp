require_relative '../../ttt/src/ttt_rules.rb'
require_relative '../../ttt/src/board.rb'

RSpec.describe TTTRules do

    class Game
        include TTTRules
        def initialize
            @board = Board.new 
        end
    end

    let(:game) { Game.new }

   context "#winner?" do
       it "should return true if there is a winner" do
           game.board.spaces = ["X","X","X",4,5,6,7,8,9]
           expect(game.winner?).to eq true
           game.board.spaces = ["X",2,3,4,"X",6,7,8,"X"]
           expect(game.winner?).to eq true
           game.board.spaces = [1,2,"X",4,"X",6,"X",8,9]
           expect(game.winner?).to eq true
           game.board.spaces = [1,2,"X",4,5,"X",7,8,"X"]
           expect(game.winner?).to eq true
       end
   end

   context "#winner" do
       it "should return the winner" do
         game.board.spaces = ["X","X","X",4,5,6,7,8,9]          
         expect(game.winner).to eq "X"
       end

       it "should return nil if there is no winner" do
           game.board.spaces = [1,2,3,4,5,6,7,8,9]
           expect(game.winner).to eq nil
       end
   end

   context "#tie" do
       it "should return true if there is a tie" do
           game.board.spaces = ["X","O","X","X","X","O","O","X","O"]
           expect(game.tie?).to eq true
       end

       it "should return false if there is not a tie" do
           game.board.spaces = ["X","O","X","O","X","O","X","O","X"]
           expect(game.tie?).to eq false
       end
   end

   context "#over?" do
       it "should return true if the game is over" do
           game.board.spaces = ["X","O","X","X","X","O","O","X","O"]
           expect(game.over?).to eq true
           game.board.spaces = ["X","O","X","O","X","O","X","O","X"]
           expect(game.over?).to eq true
       end

       it "should return false if the game is not over" do
           game.board.spaces = [1,2,3,4,5,6,7,8,9]
           expect(game.over?).to eq false
       end
   end
end
