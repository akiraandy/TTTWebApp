require_relative '../../ttt/src/game_controller'

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
    it "should return a Turn" do
      spot = 1
      human.take_turn({spot: spot})
      expect(human.take_turn({spot: spot})).to be_a(Player::Turn)
    end
  end

end
