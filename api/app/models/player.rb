
class Player < ApplicationRecord
  validates :username, presence: true

  has_many :game_players

  def resume 
    { username: }
  end
end
