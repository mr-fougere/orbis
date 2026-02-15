class AddGameModeToGameConfigurations < ActiveRecord::Migration[8.1]
  def change
    add_column :game_configurations, :game_mode, :integer
  end
end
