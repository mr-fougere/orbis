require 'benchmark'

def build_board(size: 8)
  Array.new(size) do |x|
    Array.new(size) do |y|
      { x: x, y: y }
    end
  end
end

COLORS = ['black', 'white']
DIRECTIONS = {
  north:      { x: 0,  y: 1  },
  north_east: { x: 1,  y: 1  },
  east:       { x: 1,  y: 0  },
  south:      { x: 0,  y: -1 },
  west:       { x: -1, y: 0  },
  north_west: { x: -1, y: 1  },
  south_east: { x: 1,  y: -1 },
  south_west: { x: -1, y: -1 }
}

def center_cells(board)
  size = board.size
  mid = size / 2

  [
    board[mid - 1][mid - 1],
    board[mid - 1][mid],
    board[mid][mid - 1],
    board[mid][mid]
  ]
end

def initial_disks(board)
  centers = center_cells(board)

  centers[0][:color] = 'white'
  centers[1][:color] = 'black'
  centers[2][:color] = 'black'
  centers[3][:color] = 'white'

  board
end



def in_bounds?(board, x, y)
  x.between?(0, board.size - 1) && y.between?(0, board.size - 1)
end

def possible_positions_from_player_cells(board, color)
  opponent_color = color == 'black' ? 'white' : 'black'
  color_cells = board.flatten.select { |c| c[:color] == color }

  possibles = []

  color_cells.each do |cell|
    DIRECTIONS.values.each do |dir|

      x = cell[:x] + dir[:x]
      y = cell[:y] + dir[:y]
      range = 1

      next unless in_bounds?(board, x, y) && board[x][y][:color] == opponent_color

      loop do
        x += dir[:x]
        y += dir[:y]
        range += 1

        break unless in_bounds?(board, x, y)

        current = board[x][y]

        if current[:color].nil? && range > 1
          possibles << current
          break
        end

        break if current[:color] == color
      end
    end
  end

  possibles.uniq
end


def flipped_disk_from_disk(board, disk)
  opponent_color = flip_color(disk[:color])
  flipped = []

  DIRECTIONS.each do |_, dir|
    x = disk[:x] + dir[:x]
    y = disk[:y] + dir[:y]

    temp = []

    # La première case doit être adverse
    next unless in_bounds?(board, x, y) && board[x][y][:color] == opponent_color

    while in_bounds?(board, x, y)
      current = board[x][y]

      break if current[:color].nil?

      if current[:color] == opponent_color
        temp << current
      elsif current[:color] == disk[:color]
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



def flip_color(color)
  color == 'black' ? 'white' : 'black'
end

def display_board(board, possible_spots = [])
  board.each do |row|
    puts row.map { |cell|
      if cell[:color]
        "[#{cell[:color][0].upcase}]"
      elsif possible_spots.include?(cell)
        "[X]"
      else
        "[ ]"
      end
    }.join
  end
end

def flip_disk_board(board, flipped_disk = [])
  board.each do |row|
    row.map { |cell|
      next if !flipped_disk.include?(cell)
      
      cell[:color] = flip_color(cell[:color])
    }
  end
end

def puts_disk_board(board, disk, color)
  board[disk[:x]][disk[:y]][:color] = color

  flipped_disks = flipped_disk_from_disk(board, board[disk[:x]][disk[:y]])
  ##puts flipped_disks
  flip_disk_board(board, flipped_disks)

end

def winner?(board)
  black, white = board.flatten.partition { |cell| cell[:color] == "black" }
  if black.size > white.size
    "black wins with #{black.size}"
  elsif white.size > black.size
    "white wins  #{white.size}"
  else
    'tie'
  end
end

# ---- EXECUTION ----
board = build_board
initial_disks(board)

prng =  Random.new

skip_in_row = 0

puts 'début'

while skip_in_row < 2

  COLORS.each do |color|
    possible = possible_positions_from_player_cells(board, color)
    ##display_board(board, possible)

    next skip_in_row += 1 if possible.size === 0

    puts_disk_board(board, possible[prng.rand(possible.size)], color)

    skip_in_row = 0
    display_board(board)
    puts ""
  end
end



puts 'fin de partie'

puts winner?(board)

