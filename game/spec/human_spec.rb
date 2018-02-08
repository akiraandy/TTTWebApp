require_relative '../game_controller'

RSpec.describe Human do
  let(:human) { Human.new("X", true) }
  let(:other_player) { Human.new("O") }
  let(:game) { Game_Controller.new(human, other_player) }

  before do
    $stdin = StringIO.new("1")
  end

  after do
    $stdin = STDIN
  end

  it "should inherit marker from parent class" do
    player1 = Human.new("X")
    expect(player1.marker).to eq ("X")
  end

  context "#take_turn" do
    it "should fill board with marker" do
      spot = 1
      human.take_turn(game, spot)
      expect(game.board.available_spaces.length).to eq(game.board.spaces.length - 1)
    end
  end

end
