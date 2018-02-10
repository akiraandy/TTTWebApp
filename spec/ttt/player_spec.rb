require_relative '../../ttt/src/player'

RSpec.describe Player do
  let(:player) { Player.new("X")}
  it "should have a marker" do
    expect(player.marker).to eq("X")
  end
end
