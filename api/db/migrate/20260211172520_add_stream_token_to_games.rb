class AddStreamTokenToGames < ActiveRecord::Migration[8.1]
  def change
    add_column :games, :stream_token, :string
    add_index :games, :stream_token, unique: true
  end
end
