
class Player < ApplicationRecord
  validates :username, presence: true

  has_many :game_players

  attr_accessor :username

  def resume 
    { username: }
  end
end
