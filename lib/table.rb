require_relative 'field'
require_relative 'coords'
require "deep_clone"


class Table
  def initialize
    @width  = 8
    @height = 8
    @size   = @width * @height
    @fields = Array.new(@size).map.with_index do |_,i|
      Field.new(index_to_chess_coords(i))
    end
    @history = []
  end

  def put(figure, coords)
    field = get_field(coords)
    if field.figure
      raise 'Field is already taken!'
    else
      field.figure = figure
    end
  end

  def move(coords1, coords2)
    field1  = get_field(coords1)
    field2  = get_field(coords2)
    figure1 = field1.figure
    
    if figure1 && figure1.transition_legal?(self, coords1, coords2)
      @history.push(DeepClone.clone(@fields))
      field1.figure = nil
      field2.figure = figure1
    else
      raise "Illegal move!"
    end
  end

  def undo_last_move!
    @fields = @history.pop
  end

  def get_fields_where_transition_legal(figure, start)
    @fields.select { |f| figure.transition_legal?(self, start, f.coords) }
  end
  
  def get_figure(coords)
    get_field(coords).figure
  end

  def get_figures(path)
    path.map { |coords| get_figure(coords) }
  end
  
  def get_fields_where_are_figures_of(color)
    @fields.select { |f| f.figure && f.figure.color == color }
  end

  def get_field_where_king_of(color)
    @fields.select {|f| f.figure.is_a?(King)  && f.figure.color == color}.first
  end

  def vertical_path_clear?(coords1, coords2)
    # check is there any figure between two coords in the same column
    figs = get_figures(coords1.get_vertical_path(coords2))
    path_clear(figs)
  end

  def horizontal_path_clear?(coords1, coords2)
    figs = get_figures(coords1.get_horizontal_path(coords2))
    path_clear(figs)
  end

  def rising_diagonal_path_clear?(coords1, coords2)
    figs = get_figures(coords1.get_rising_diagonal_path(coords2))
    path_clear(figs)
  end

  def falling_diagonal_path_clear?(coords1, coords2)
    figs = get_figures(coords1.get_falling_diagonal_path(coords2))
    path_clear(figs)
  end
  
  def print_table
    # Unicode elements taken from:
    # http://www.utf8-chartable.de/unicode-utf8-table.pl?start=9600&number=128

    field_width = 5
    half_width  = (field_width - 1) / 2
    
    hline_top    = "    #{"\u2581" * 8 * field_width}"
    hline_bottom = "    #{"\u2594" * 8 * field_width}"

    letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H']
    puts
    puts "#{' '*(4+half_width)}#{letters.join(' ' * (field_width-1))}"
    puts hline_top
    
    (@height-1).downto(0) do |row|

      blank_line  = ""
      figure_line = ""
      
      @width.times do |col|
        coords = ChessCoords.new(col, row)
        field  = get_field(coords)

        blank_line  += field.color * field_width
        figure_line += "#{field.color*half_width}#{field}#{field.color*half_width}"       
      end
      puts "   #{"\u2595"}#{blank_line}#{"\u258F"}"
      puts " #{row+1} #{"\u2595"}#{figure_line}#{"\u258F"}"
      puts "   #{"\u2595"}#{blank_line}#{"\u258F"}"
    end
    puts hline_bottom
    puts "#{' '*(4+half_width)}#{letters.join(' ' * (field_width-1))}"
  end

  private 
  def get_field(coords)
    @fields[chess_coords_to_index(coords)]
  end
  
  def chess_coords_to_index(position)
    position.y * @width + position.x
  end

  def index_to_chess_coords(index)
    x = index % @width
    y = index / @width / 1 # ignore '/ 1', texteditor highlighting issue...
    ChessCoords.new(x,y)
  end

  def path_clear(figs)
    figs[1...-1].all? { |f| f.nil? }
  end
end
