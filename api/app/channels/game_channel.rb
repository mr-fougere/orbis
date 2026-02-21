class GameChannel < ApplicationCable::Channel
  def subscribed
    @game = Game.find_by(code: params[:token])
    reject unless @game

    manager = GameManager.new(
      game: @game,
      current_player: current_player # via connection
    )

    reject unless manager.connect!

    stream_for @game

    GameChannel.broadcast_to(@game, {
      type: "game_status",
      status: @game.status
    })
  end

  def unsubscribed
    game_player = @game.game_players.find_by(player: current_player)
    game_player&.update(status: :disconnected)
  end

  def get_game_state
    state = OthelloEngine.new(game: @game).get_game_state
    GameChannel.broadcast_to(@game, { event: 'game_state', data: state })
  end

  def put_disks(data)
    engine = OthelloEngine.new(game: @game)
    success = engine.put_disk(x: data['x'], y: data['y'])
    if success
      GameChannel.broadcast_to(@game, { event: 'game_state', data: engine.update_game_state })
    end
  end

  private

  def find_game_player
     self.current_game_player = @game.game_players.find_by(player: current_player)
  end
end
