class Game < ApplicationRecord

  has_one :game_configuration
  has_many :game_players
  validates :code, uniqueness: true

  before_create :generate_code

  enum :status, { pending: 0, in_progress: 1, finished: 2 }

  def generate_code
    characters = [('0'..'9'), ('A'..'Z')].map(&:to_a).flatten
    generated_code = (0...6).map { characters[rand(characters.length)] }.join
    self.code = generated_code
  end
end