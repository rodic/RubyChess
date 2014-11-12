require 'set'

class ChessCoords
  attr_reader :x, :y
  
  @@letters = Set.new ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H']
  @@nums    = Set.new [ 1,   2,   3,   4,   5,   6,   7,   8 ]
  
  # initialize it either with (2,1) or (C,1)...
  def initialize(x,y)

    validate(x,y)
    
    if x.is_a? Numeric
      @x = x
      @y = y
    else
      @x = letter_to_num(x)
      @y = y-1
    end
  end

  def inc_x(n=1)
    ChessCoords.new(x+n, y)
  end

  def inc_y(n=1)
    ChessCoords.new(x,y+n)
  end
  
  def in_same_column?(other)
    self.x == other.x
  end

  def in_same_row?(other)
    self.y == other.y
  end

  def on_same_rising_diagonal?(other)
    (self.x - other.x) == (self.y - other.y)
  end

  def on_same_falling_diagonal?(other)
    (self.x - other.x) == -(self.y - other.y)
  end

  def get_vertical_path(coords)
    increment = self.y < coords.y ? 1 : -1
    get_path(coords, increment) { |c,i| c.inc_y(i)}
  end

  def get_horizontal_path(coords)
    increment = self.x < coords.x ? 1 : -1
    get_path(coords, increment) { |c,i| c.inc_x(i)}
  end

  def get_rising_diagonal_path(coords)
    increment = self.x < coords.x ? 1 : -1
    get_path(coords, increment) { |c,i| c.inc_x(i).inc_y(i)}
  end

  def get_falling_diagonal_path(coords)
    increment = self.y < coords.y ? 1 : -1
    get_path(coords, increment) { |c,i| c.inc_x(-i).inc_y(i)}
  end
  
  def ==(other)
    x == other.x && y == other.y
  end

  def to_s
    "(#{num_to_letter(x)}, #{y+1})"
  end
  
  private
  def num_to_letter(n)
    ("A".ord + n).chr
  end

  def letter_to_num(l)
    l.upcase.ord - "A".ord
  end

  def get_path(coords, inc)
    start = self
    path  = [start]
    until start == coords
      start = yield(start, inc)
      path << start
    end
    path
  end
  
  def validate(x,y)
    x = x.is_a?(Numeric) ? x : x.upcase
    unless (@@letters.include?(x) && @@nums.include?(y)) ||
           (@@nums.include?(x+1)  && @@nums.include?(y+1))
      raise 'Invalid coords!'
    end
  end
end
