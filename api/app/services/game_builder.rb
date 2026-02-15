class GameBuilder
  DEFAULT_GAME_CONFIGURATION = {
    board: {
      width: 8,
      height: 8
    },
    initial_disks: [
      { x: 4, y: 4, side: :recto },
      { x: 5, y: 4, side: :verso },
      { x: 4, y: 5, side: :recto },
      { x: 5, y: 5, side: :verso }
    ],
    game_mode: :player_vs_bot
  }.freeze

  def initialize(game_configuration: {}, admin_player:)
    @config = DEFAULT_GAME_CONFIGURATION.deep_merge(game_configuration)
    @admin_player = admin_player
  end

  def build!
    ActiveRecord::Base.transaction do
      game = create_game
      create_game_configuration(game)
      create_admin_game_player(game)

      board = build_board

      game.update!(
        board_state: build_initial_board_state(board),
        status: :pending
      )

      game.define_singleton_method(:board) { board }

      game
    end
  end

  private

  def create_game
    Game.create!
  end

  def create_game_configuration(game)
    GameConfiguration.create!(
      game: game,
      board_width: @config[:board][:width],
      board_height: @config[:board][:height],
      initial_disks: @config[:initial_disks],
      starting_side: :recto
    )
  end

  def create_admin_game_player(game)
    game.game_players.create!(
      player: @admin_player,
      side: :recto,
      is_admin: true
    )
  end

  def build_board
    disks = @config[:initial_disks].map do |d|
      GameDisk.new(
        x: d[:x],
        y: d[:y],
        side: d[:side]
      )
    end

    GameBoard.new(
      dimension: @config[:board],
      disks: disks
    )
  end

  def build_initial_board_state(board)
    {
      board: board.to_snapshot,
      current_turn: :recto,
      last_disk: nil,
      flipped_disks: []
    }
  end

end
