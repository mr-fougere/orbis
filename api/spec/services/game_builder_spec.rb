require "rails_helper"

RSpec.describe GameBuilder do
  let(:admin_player) { create(:player) }

  describe "#build!" do
    subject(:builder) { described_class.new(game_configuration: {}, admin_player: admin_player) }

    let(:game) { builder.build! }

    it "creates a new Game" do
      expect { builder.build! }.to change(Game, :count).by(1)
      expect(game).to be_a(Game)
      expect(game.status).to eq("pending")
    end

    it "creates a GamePlayer for the admin" do
      expect(game.game_players.count).to eq(1)
      admin_game_player = game.game_players.first

      expect(admin_game_player.player).to eq(admin_player)
      expect(admin_game_player.side).to eq("recto")
      expect(admin_game_player.is_admin).to eq(true)
    end

    it "builds a GameBoard with initial disks" do
      board = game.board
      expect(board).to be_a(GameBoard)

      # Vérifie que les 4 disks initiaux sont là
      positions = board.game_disks.values.map { |d| [d.x, d.y] }
      expect(positions).to include([4,4], [5,4], [4,5], [5,5])

      # Vérifie que chaque disk a le bon side
      disk_at_44 = board.disk_at(4,4)
      expect(disk_at_44.side).to eq(:recto)

      disk_at_54 = board.disk_at(5,4)
      expect(disk_at_54.side).to eq(:verso)
    end

    it "saves the board_state snapshot in the game" do
      snapshot = game.board_state
      expect(snapshot).to be_an(Array)
      expect(snapshot.size).to eq(4)

      first_disk = snapshot.find do |d| 
        d.deep_symbolize_keys[:position] == { x: 4, y: 4 }
      end
      expect(first_disk.deep_symbolize_keys[:side]).to eq("recto")
    end
  end
end
