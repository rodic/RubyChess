require_relative 'coords'
require_relative 'figures'
require_relative 'table'
require_relative 'players'


class Game
  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
    @table   = Table.new
  end

  def play
    puts "Welcome to the Ruby chess!"
    puts
    puts " * To move a figure from a2 to a4 type 'a2a4'"

    set_figures
    move_counter = 0

    loop do
      @table.print_table
      player = move_counter % 2 == 0 ? @player1 : @player2

      if is_chess?(player.color)
        if is_checkmate?(player.color)
          puts "Checkmate! #{move_counter % 2 != 0 ? @player1 : @player2} won!"
          break
        else
          print "#{player} you are attacked! Protect your king: "
        end
      else
        print "#{player} please enter your move: "
      end

      c1, c2 = parse_move(player.perform_move)

      begin
        @table.move(c1, c2)
        move_counter += 1
      rescue Exception => e
        puts "#{e} Try again!"
      end

      # if player performed a move which exposed its king
      if is_chess?(player.color)
        move_counter -= 1
        @table.undo_last_move!
      end
    end
  end

  private
  def is_checkmate?(color)
    @table.get_fields_where_are_figures_of(color).each do |f1|
      fig   = f1.figure
      start = f1.coords
      @table.get_fields_where_transition_legal(fig, start).each do |f2|
        target = f2.coords
        @table.move(start, target)
        chess = is_chess?(color)
        @table.undo_last_move!
        return false unless chess
      end
    end
    true
  end

  def is_chess?(color)
    figs = @table.get_fields_where_are_figures_of(
           color==:white ? :black : :white)
    king = @table.get_field_where_king_of(color)
    figs.any? { |f| f.figure.transition_legal?(@table, f.coords, king.coords) }
  end

  def parse_move(move)
    c1 = ChessCoords.new(move[0], move[1].to_i)
    c2 = ChessCoords.new(move[2], move[3].to_i)
    [ c1, c2 ]
  end

  def set_figures
    [ :white, :black ].each do |color|

      if color == :white
        row1 = 1
        row2 = 2
      else
        row1 = 8
        row2 = 7
      end

      @table.put(King.new(color), ChessCoords.new('E', row1))
      @table.put(Queen.new(color), ChessCoords.new('D', row1))
      @table.put(Rook.new(color), ChessCoords.new("A", row1))
      @table.put(Rook.new(color), ChessCoords.new("H", row1))
      @table.put(Bishop.new(color), ChessCoords.new("C", row1))
      @table.put(Bishop.new(color), ChessCoords.new("F", row1))
      @table.put(Knight.new(color), ChessCoords.new("B", row1))
      @table.put(Knight.new(color), ChessCoords.new("G", row1))
      ("A".."H").each do |l|
        @table.put(Pawn.new(color), ChessCoords.new(l, row2))
      end
    end
  end
end
