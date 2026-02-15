class CreateGamePlayers < ActiveRecord::Migration[8.1]
  def change
    create_table :game_players do |t|
      t.references :player,  null: false, foreign_key: true
      t.references :game,  null: false, foreign_key: true
      t.integer :side, null: false
      t.boolean :is_admin, default: false, null: false
      t.timestamps
    end
  end
end
