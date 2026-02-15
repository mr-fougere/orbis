class CreateGameConfigurations < ActiveRecord::Migration[8.1]
  def change
    create_table :game_configurations do |t|
      t.integer :board_width, default: 8, null: false
      t.integer :board_height, default: 8, null: false
      t.jsonb :initial_disks, default: [], null: false
      t.references :game, null: false, foreign_key: true
      t.integer :starting_side, default: 0, null: false # 0 = recto, 1 = verso
      t.timestamps
    end
  end
end
