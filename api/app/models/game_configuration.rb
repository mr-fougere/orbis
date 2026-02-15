class GameConfiguration < ApplicationRecord

  belongs_to :game

  enum :starting_side,  %i[recto verso]
  enum :game_mode, %i[player_vs_player player_vs_bot]

  def public_infos
    {
      board_width:,
      board_height:,
      initial_disks:,
      starting_side:,
      game_mode:
    }
  end

end