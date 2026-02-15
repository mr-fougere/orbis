class GameBoard

  DEFAULT_DIMENSION = { width: 8, height: 8 }
  
  attr_reader :game_disks

  def initialize(dimension: DEFAULT_DIMENSION, disks: [])
    @dimension = dimension
    @max_disks_count = @dimension[:height] * @dimension[:width]
    @game_disks = {}

    disks.each { |disk| add_disk(disk) }
  end

  def add_disk(disk)
    key = key_for(disk.x, disk.y)
    @game_disks[key] = disk
  end

  def disk_at(x, y)
    @game_disks[key_for(x, y)]
  end

  def empty_at?(x, y)
    !disk_at(x, y)
  end

  def flip_disk(x, y)
    disk_at(x, y)&.flip!
  end

  def counts
    @game_disks.values.group_by(&:side).transform_values(&:count)
  end

  def full?
    @game_disks.size == @max_disks_count
  end

  def to_snapshot
    @game_disks.values.map(&:to_h)
  end

  private

  def key_for(x, y)
    "#{x}-#{y}"
  end
end
