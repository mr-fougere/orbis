class GameDisk
  SIDES = %i[recto verso].freeze
  attr_reader :x, :y, :side

  def initialize(x:, y:, side:)
    raise ArgumentError, "Invalid side" unless SIDES.include?(side)

    @side = side
    @x = x
    @y = y
  end

  def position
    { x: x, y: y }
  end

  def owner
    side == :recto ? 1 : 2
  end

  def flip!
    @side = (@side == :recto ? :verso : :recto)
  end

  def to_h
    { side: , position: }
  end
end
