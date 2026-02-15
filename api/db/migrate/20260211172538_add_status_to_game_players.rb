class AddStatusToGamePlayers < ActiveRecord::Migration[8.1]
  def change
    add_column :game_players, :status, :integer
  end
end
