class Field
  attr_reader :color
  attr_accessor :figure, :coords
  
  def initialize(coords)
    @coords = coords
    @color  = coords.x % 2 == coords.y % 2 ? "\u2591" : " "
    @figure = nil
  end
  
  def has_figure?
    !@figure.nil?
  end

  def to_s
    has_figure? ? figure.to_s : color
  end
end
