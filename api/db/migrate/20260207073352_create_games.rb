class CreateGames < ActiveRecord::Migration[8.1]
  def change
    create_table :games do |t|
      t.string :code, null: false
      t.jsonb :board_state, default: [], null: false
      t.integer :status, default: 0

      t.timestamps
    end

    add_index :games, :code, unique: true
  end
end
