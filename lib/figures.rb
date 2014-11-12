require 'set'

class Figure
  attr_reader :color, :white, :black
  
  def initialize(color)
    @color = color
  end

  def to_s
    @color == :white ? white : black
  end

  def transition_legal?(table, target_coords)
    # no figure can take a place of a figure with the same color
    fig = table.get_figure(target_coords)
    return fig ? color != fig.color : true
  end
end


class Queen < Figure
  
  def initialize(color)
    @white = "\u2655"
    @black = "\u265B"
    super(color)
  end

  def transition_legal?(table, coords1, coords2)    
    return false unless super(table, coords2)
    if coords1.in_same_column?(coords2)
      table.vertical_path_clear?(coords1, coords2)
    elsif coords1.in_same_row?(coords2)
      table.horizontal_path_clear?(coords1, coords2)
    elsif coords1.on_same_rising_diagonal?(coords2)
      table.rising_diagonal_path_clear?(coords1, coords2)
    elsif coords1.on_same_falling_diagonal?(coords2)
      table.falling_diagonal_path_clear?(coords1, coords2)
    else
      false
    end
  end
end


class King < Figure
  def initialize(color)
    @white = "\u2654"
    @black = "\u265A"
    super(color)
  end
  
  def transition_legal?(table, coords1, coords2)
    return false unless super(table, coords2)
    (coords1.x - coords2.x).abs < 2 && (coords1.y - coords2.y).abs < 2
  end
end


class Rook < Figure
  def initialize(color)
    @white = "\u2656"
    @black = "\u265C"
    super(color)
  end

  def transition_legal?(table, coords1, coords2)
    return false unless super(table, coords2)
    if coords1.in_same_column?(coords2)
      table.vertical_path_clear?(coords1, coords2)
    elsif coords1.in_same_row?(coords2)
      table.horizontal_path_clear?(coords1, coords2)
    else
      false
    end
  end
end


class Bishop < Figure
  def initialize(color)
    @white = "\u2657"
    @black = "\u265D"
    super(color)
  end

  def transition_legal?(table, coords1, coords2)
    return false unless super(table, coords2)
    if coords1.on_same_rising_diagonal?(coords2)
      table.rising_diagonal_path_clear?(coords1, coords2)
    elsif coords1.on_same_falling_diagonal?(coords2)
      table.falling_diagonal_path_clear?(coords1, coords2)
    else
      false
    end
  end
end


class Knight < Figure
  def initialize(color)
    @white = "\u2658"
    @black = "\u265E"
    super(color)
  end

  def transition_legal?(table, coords1, coords2)
    return false unless super(table, coords2)
    ((coords1.x - coords2.x).abs == 2 && (coords1.y - coords2.y).abs == 1) ||
    ((coords1.x - coords2.x).abs == 1 && (coords1.y - coords2.y).abs == 2)
  end
end


class Pawn < Figure
  def initialize(color)
    @white = "\u2659"
    @black = "\u265F"
    super(color)
  end

  def transition_legal?(table, coords1, coords2)
    return false unless super(table, coords2)
    
    y_dif = color == :white ? Set.new([1]) : Set.new([-1])

    # if it's on the starting position it can jump two fields
    if (color == :white && coords1.y == 1)
      y_dif.add(2)
    elsif (color == :black && coords1.y == 6)
      y_dif.add(-2)
    end

    # it can move diagonaly to eat a figure of different color
    x_dif = table.get_figure(coords2) ? 1 : 0
    
    y_dif.include?(coords2.y-coords1.y) && ((coords2.x-coords1.x).abs == x_dif)
  end
end
