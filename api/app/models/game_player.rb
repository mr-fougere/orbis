class GamePlayer < ApplicationRecord 

  belongs_to :game
  belongs_to :player

  enum :side,  %i[recto verso]
  enum :status, %i[disconnected connected]

  scope :connected, -> { where(status: :connected) }
end