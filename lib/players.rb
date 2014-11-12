class Player
  attr_reader :color
  def initialize(color)
    @color = color
  end

  def perform_move
    gets.chomp
  end

  def to_s
    "[#{@color.upcase}]"
  end
end
