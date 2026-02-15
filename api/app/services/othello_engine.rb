class OthelloEngine
  DIRECTIONS = {
    north:      { x: 0,  y: 1  },
    north_east: { x: 1,  y: 1  },
    east:       { x: 1,  y: 0  },
    south:      { x: 0,  y: -1 },
    west:       { x: -1, y: 0 },
    north_west: { x: -1, y: 1 },
    south_east: { x: 1,  y: -1 },
    south_west: { x: -1, y: -1 }
  }

  SIDES = %i[recto verso]

  attr_reader :board, :game, :board_state

  def initialize(game:)
    @game = game
    load_board_state
  end

  # ----- ACTION 1 : GET GAME STATE -----
  def get_game_state
    {
      board: board_state['board'],
      current_turn: board_state['current_turn'],
      last_disk: board_state['last_disk'],
      flipped_disks: board_state['flipped_disks'],
      possible_positions: possible_positions_from_player_cells(board_state['current_turn'].to_sym)
    }
  end

  # ----- ACTION 2 : PUT DISKS -----
  def put_disk(x:, y:)
    side = board_state['current_turn'].to_sym
    possible = possible_positions_from_player_cells(side)
    disk = possible.find { |d| d[:x] == x && d[:y] == y }
    return false unless disk

    flipped = flipped_disk_from_disk(board_state['board'], disk.merge(side: side))

    # update board
    board_state['board'][disk[:x]][disk[:y]][:side] = side
    flip_disk_board(flipped)

    # update state JSON
    board_state['last_disk'] = { x: x, y: y, side: side }
    board_state['flipped_disks'] = flipped
    board_state['current_turn'] = flip_side(side).to_s

    game.update!(board_state: board_state)
    true
  end

  # ----- ACTION 3 : UPDATE GAME STATE -----
  def update_game_state
    get_game_state
  end

  # ----- HELPERS -----
  private

  def load_board_state
    @board_state = game.board_state.presence || default_board_state
    @board_state['board'] = build_board if @board_state['board'].empty?
    @board_state['current_turn'] ||= 'recto'
    @board_state['last_disk'] ||= nil
    @board_state['flipped_disks'] ||= []
    game.update!(board_state: @board_state)
  end

  def default_board_state
    { board: [], current_turn: 'recto', last_disk: nil, flipped_disks: [] }
  end

  def build_board(size: 8)
    Array.new(size) { |x| Array.new(size) { |y| { x: x, y: y, side: nil } } }
  end

  def initial_disks(board)
    mid = board.size / 2
    board[mid - 1][mid - 1][:side] = :verso
    board[mid - 1][mid][:side]     = :recto
    board[mid][mid - 1][:side]     = :recto
    board[mid][mid][:side]         = :verso
  end

  def in_bounds?(x, y)
    x.between?(0, board_state['board'].size - 1) && y.between?(0, board_state['board'].size - 1)
  end

  def possible_positions_from_player_cells(side)
    opponent = flip_side(side)
    color_cells = board_state['board'].flatten.select { |c| c[:side] == side }
    possibles = []

    color_cells.each do |cell|
      DIRECTIONS.values.each do |dir|
        x, y = cell[:x] + dir[:x], cell[:y] + dir[:y]
        next unless in_bounds?(x, y) && board_state['board'][x][y][:side] == opponent

        range = 1
        loop do
          x += dir[:x]
          y += dir[:y]
          range += 1
          break unless in_bounds?(x, y)

          current = board_state['board'][x][y]
          if current[:side].nil? && range > 1
            possibles << current
            break
          end
          break if current[:side] == side
        end
      end
    end
    possibles.uniq
  end

  def flipped_disk_from_disk(disk)
    side = disk[:side].to_sym
    opponent = flip_side(side)
    flipped = []

    DIRECTIONS.each do |_, dir|
      x, y = disk[:x] + dir[:x], disk[:y] + dir[:y]
      temp = []

      next unless in_bounds?(x, y) && board_state['board'][x][y][:side] == opponent

      while in_bounds?(x, y)
        current = board_state['board'][x][y]
        break if current[:side].nil?

        if current[:side] == opponent
          temp << current
        elsif current[:side] == side
          flipped.concat(temp)
          break
        else
          break
        end

        x += dir[:x]
        y += dir[:y]
      end
    end
    flipped
  end

  def flip_disk_board(disks)
    disks.each do |cell|
      board_state['board'][cell[:x]][cell[:y]][:side] = flip_side(board_state['board'][cell[:x]][cell[:y]][:side])
    end
  end

  def flip_side(side)
    side == :recto ? :verso : :recto
  end
end
