class GameManager
  def initialize(game:, current_player:)
    @game = game
    @current_player = current_player
  end

  def connect!
    game_player = @game.game_players.find_by(player: @current_player)

    # Si le joueur n'existe pas encore
    unless game_player
      return false unless can_join?

      game_player = create_second_player!
    end

    game_player.update!(status: :connected)

    try_start_game!

    true
  end

  private

  def can_join?
    @game.game_configuration.player_vs_player? &&
      @game.game_players.connected.count < 2
  end

  def create_second_player!
    side = @game.game_players.first.side == "recto" ? :verso : :recto

    @game.game_players.create!(
      player: @current_player,
      side: side,
      is_admin: false,
      status: :connected
    )
  end

  def try_start_game!
    if @game.game_configuration.player_vs_player?
      if @game.game_players.connected.count == 2
        @game.update!(status: :in_progress)
      end
    else
      # player_vs_bot
      if admin_connected?
        @game.update!(status: :in_progress)
      end
    end
  end

  def admin_connected?
    @game.game_players.find_by(is_admin: true)&.connected?
  end
end
