require 'figures'
require 'table'

describe Figure do
  let(:table) { Table.new }
  let(:fig1) { Pawn.new(:white) }
  let(:fig2) { Pawn.new(:white) }

  it "cannot move on a field where the fig of the same color is" do
    from = ChessCoords.new("E", 4)
    to   = ChessCoords.new("H", 1)
    table.put(fig1, from)
    table.put(fig2, to)
    expect { table.move(from, to) }.to raise_error("Illegal move!")
  end
end


describe Queen do

  let(:table) { Table.new }
  let(:queen) { Queen.new(:white) }
  
  
  describe "#transition_legal?" do
    context "No obstacles" do
      it "can move along x-axis from left to right" do
        from = ChessCoords.new("C", 4)
        to   = ChessCoords.new("G", 4)
        table.put(queen, from)
        table.move(from, to)
        expect(table.get_figure(to)).to eq(queen)
      end

      it "can move along x-axis from right to left" do
        from = ChessCoords.new("H", 7)
        to   = ChessCoords.new("A", 7)
        table.put(queen, from)
        table.move(from, to)
        expect(table.get_figure(to)).to eq(queen)
      end
    
      it "can move along y-axis from bootom to top" do
        from = ChessCoords.new("B", 1)
        to   = ChessCoords.new("B", 4)
        table.put(queen, from)
        table.move(from, to)
        expect(table.get_figure(to)).to eq(queen)
      end

      it "can move along y-axis from top to bottom" do
        from = ChessCoords.new("E", 8)
        to   = ChessCoords.new("E", 2)
        table.put(queen, from)
        table.move(from, to)
        expect(table.get_figure(to)).to eq(queen)
      end

      it "can move along rising diagonal bottom to top" do
        from = ChessCoords.new("A", 2)
        to   = ChessCoords.new("D", 5)
        table.put(queen, from)
        table.move(from, to)
        expect(table.get_figure(to)).to eq(queen)
      end

      it "can move along rising diagonal top to bottom" do
        from = ChessCoords.new("H", 4)
        to   = ChessCoords.new("E", 1)
        table.put(queen, from)
        table.move(from, to)
        expect(table.get_figure(to)).to eq(queen)
      end

      it "can move along falling diagonal bottom to top" do
        from = ChessCoords.new("F", 5)
        to   = ChessCoords.new("C", 8)
        table.put(queen, from)
        table.move(from, to)
        expect(table.get_figure(to)).to eq(queen)
      end

      it "can move along falling diagonal top to bottom" do
        from = ChessCoords.new("B", 4)
        to   = ChessCoords.new("D", 2)
        table.put(queen, from)
        table.move(from, to)
        expect(table.get_figure(to)).to eq(queen)
      end
    end

    context "There are figures in the way" do

      let(:fig) { Figure.new(:black) }
      
      it "cannot move along x-axis from left to right" do
        from = ChessCoords.new("C", 4)
        to   = ChessCoords.new("G", 4)
        obst = ChessCoords.new("D", 4)
        table.put(queen, from)
        table.put(fig, obst)
        expect {table.move(from, to)}.to raise_error("Illegal move!")
      end

      it "cannot move along x-axis from right to left" do
        from = ChessCoords.new("E", 2)
        to   = ChessCoords.new("A", 2)
        obst = ChessCoords.new("B", 2)
        table.put(queen, from)
        table.put(fig, obst)
        expect {table.move(from, to)}.to raise_error("Illegal move!")
      end

      it "cannot move along y-axis bottom to top" do
        from = ChessCoords.new("F", 1)
        to   = ChessCoords.new("F", 6)
        obst = ChessCoords.new("F", 4)
        table.put(queen, from)
        table.put(fig, obst)
        expect {table.move(from, to)}.to raise_error("Illegal move!")
      end

      it "cannot move along y-axis top to bottom" do
        from = ChessCoords.new("C", 6)
        to   = ChessCoords.new("C", 4)
        obst = ChessCoords.new("C", 5)
        table.put(queen, from)
        table.put(fig, obst)
        expect {table.move(from, to)}.to raise_error("Illegal move!")
      end

      it "cannot move along rising diagonal bottom to top" do
        from = ChessCoords.new("E", 2)
        to   = ChessCoords.new("H", 5)
        obst = ChessCoords.new("G", 4)
        table.put(queen, from)
        table.put(fig, obst)
        expect {table.move(from, to)}.to raise_error("Illegal move!")
      end

      it "cannot move along rising diagonal top to bottom" do
        from = ChessCoords.new("E", 6)
        to   = ChessCoords.new("A", 2)
        obst = ChessCoords.new("C", 4)
        table.put(queen, from)
        table.put(fig, obst)
        expect {table.move(from, to)}.to raise_error("Illegal move!")
      end

      it "cannot move along falling diagonal bottom to top" do
        from = ChessCoords.new("G", 2)
        to   = ChessCoords.new("B", 7)
        obst = ChessCoords.new("D", 5)
        table.put(queen, from)
        table.put(fig, obst)
        expect {table.move(from, to)}.to raise_error("Illegal move!")
      end

      it "cannot move along falling diagonal top to bottom" do
        from = ChessCoords.new("A", 5)
        to   = ChessCoords.new("E", 1)
        obst = ChessCoords.new("C", 3)
        table.put(queen, from)
        table.put(fig, obst)
        expect {table.move(from, to)}.to raise_error("Illegal move!")
      end
    end
  end
end


describe King do
  let(:table) { Table.new }
  let(:king)  { King.new(:white) }

  describe "#transition_legal?" do

    context "By one field" do
      it "can move along x-axis from left to right" do
        from = ChessCoords.new("E", 1)
        to   = ChessCoords.new("F", 1)
        table.put(king, from)
        table.move(from, to)
        expect(table.get_figure(to)).to be(king)
      end
      
      it "can move along x-axis from right to left" do
        from = ChessCoords.new("E", 1)
        to   = ChessCoords.new("D", 1)
        table.put(king, from)
        table.move(from, to)
        expect(table.get_figure(to)).to be(king)
      end

      it "can move along y-axis bottom to top" do
        from = ChessCoords.new("F", 2)
        to   = ChessCoords.new("F", 3)
        table.put(king, from)
        table.move(from, to)
        expect(table.get_figure(to)).to be(king)
      end
      
      it "can move along y-axis top to bottom" do
        from = ChessCoords.new("C", 4)
        to   = ChessCoords.new("C", 3)
        table.put(king, from)
        table.move(from, to)
        expect(table.get_figure(to)).to be(king)
      end

      it "can move along rising diagonal bottom to top" do
        from = ChessCoords.new("B", 6)
        to   = ChessCoords.new("C", 7)
        table.put(king, from)
        table.move(from, to)
        expect(table.get_figure(to)).to be(king)
      end

      it "can move along rising diagonal top to bottom" do
        from = ChessCoords.new("G", 3)
        to   = ChessCoords.new("F", 2)
        table.put(king, from)
        table.move(from, to)
        expect(table.get_figure(to)).to be(king)
      end

      it "can move along falling diagonal bottom to top" do
        from = ChessCoords.new("G", 2)
        to   = ChessCoords.new("F", 3)
        table.put(king, from)
        table.move(from, to)
        expect(table.get_figure(to)).to be(king)
      end

      it "can move along falling diagonal top to bottom" do
        from = ChessCoords.new("B", 4)
        to   = ChessCoords.new("C", 3)
        table.put(king, from)
        table.move(from, to)
        expect(table.get_figure(to)).to be(king)
      end
    end

    context "By more than one field" do
      it "cannot move along x-axis" do
        from = ChessCoords.new("G", 5)
        to   = ChessCoords.new("E", 5)
        table.put(king, from)
        expect {table.move(from, to)}.to raise_error("Illegal move!")
      end

      it "cannot move along y-axis" do
        from = ChessCoords.new("C", 6)
        to   = ChessCoords.new("C", 4)
        table.put(king, from)
        expect {table.move(from, to)}.to raise_error("Illegal move!")
      end

      it "cannot move along rising diagonal" do
        from = ChessCoords.new("D", 2)
        to   = ChessCoords.new("F", 4)
        table.put(king, from)
        expect {table.move(from, to)}.to raise_error("Illegal move!")
      end

      it "cannot move along falling diagonal" do
        from = ChessCoords.new("E", 4)
        to   = ChessCoords.new("A", 8)
        table.put(king, from)
        expect {table.move(from, to)}.to raise_error("Illegal move!")
      end
    end
  end
end


describe Knight do

  let(:table)  { Table.new }
  let(:knight) { Knight.new(:white) }
  
  describe "#transition_legal?" do
    it "can move up right |^" do
      from = ChessCoords.new("E", 2)
      to   = ChessCoords.new("F", 4)
      table.put(knight, from)
      table.move(from, to)
      expect(table.get_figure(to)).to be(knight)
    end

    it "can move up left ^|" do
      from = ChessCoords.new("D", 6)
      to   = ChessCoords.new("C", 8)
      table.put(knight, from)
      table.move(from, to)
      expect(table.get_figure(to)).to be(knight)
    end

    it "can move down right |_" do
      from = ChessCoords.new("F", 5)
      to   = ChessCoords.new("G", 3)
      table.put(knight, from)
      table.move(from, to)
      expect(table.get_figure(to)).to be(knight)
    end

    it "can move down left _|" do
      from = ChessCoords.new("B", 6)
      to   = ChessCoords.new("A", 4)
      table.put(knight, from)
      table.move(from, to)
      expect(table.get_figure(to)).to be(knight)
    end

    it "can move right up __|" do
      from = ChessCoords.new("C", 6)
      to   = ChessCoords.new("E", 7)
      table.put(knight, from)
      table.move(from, to)
      expect(table.get_figure(to)).to be(knight)
    end

    it "can move right down ^^^|" do
      from = ChessCoords.new("F", 2)
      to   = ChessCoords.new("H", 1)
      table.put(knight, from)
      table.move(from, to)
      expect(table.get_figure(to)).to be(knight)
    end

    it "can move left up |___" do
      from = ChessCoords.new("C", 4)
      to   = ChessCoords.new("A", 5)
      table.put(knight, from)
      table.move(from, to)
      expect(table.get_figure(to)).to be(knight)
    end

    it "can move left down |^^^" do
      from = ChessCoords.new("G", 4)
      to   = ChessCoords.new("E", 3)
      table.put(knight, from)
      table.move(from, to)
      expect(table.get_figure(to)).to be(knight)
    end

    it "cannot move diagonaly" do
      from = ChessCoords.new("D", 2)
      to   = ChessCoords.new("B", 4)
      table.put(knight, from)
      expect{table.move(from, to)}.to raise_error("Illegal move!")
    end

    it "cannot move in big L" do
      from = ChessCoords.new("D", 2)
      to   = ChessCoords.new("B", 5)
      table.put(knight, from)
      expect{table.move(from, to)}.to raise_error("Illegal move!")
    end
  end
end


describe Pawn do
  let(:table)  { Table.new }
  let(:pawn_w) { Pawn.new(:white) }
  let(:pawn_b) { Pawn.new(:black) }

  it "white can move one field forward" do
    from = ChessCoords.new("D", 2)
    to   = ChessCoords.new("D", 3)
    table.put(pawn_w, from)
    table.move(from, to)
    expect(table.get_figure(to)).to be(pawn_w)
  end

  it "white cannot move one field back" do
    from = ChessCoords.new("D", 3)
    to   = ChessCoords.new("D", 2)
    table.put(pawn_w, from)
    expect{table.move(from, to)}.to raise_error("Illegal move!")
  end

  it "black can move one field forward" do
    from = ChessCoords.new("H", 7)
    to   = ChessCoords.new("H", 6)
    table.put(pawn_b, from)
    table.move(from, to)
    expect(table.get_figure(to)).to be(pawn_b)
  end

  it "black cannot move one field back" do
    from = ChessCoords.new("A", 6)
    to   = ChessCoords.new("A", 7)
    table.put(pawn_b, from)
    expect{table.move(from, to)}.to raise_error("Illegal move!")
  end

  it "white can move two fields forward from starting position" do
    from = ChessCoords.new("C", 2)
    to   = ChessCoords.new("C", 4)
    table.put(pawn_w, from)
    table.move(from, to)
    expect(table.get_figure(to)).to be(pawn_w)
  end

  it "black can move two fields forward from starting position" do
    from = ChessCoords.new("F", 7)
    to   = ChessCoords.new("F", 5)
    table.put(pawn_b, from)
    table.move(from, to)
    expect(table.get_figure(to)).to be(pawn_b)
  end

  it "white cannot move two fields if not on starting position" do
    from = ChessCoords.new("H", 3)
    to   = ChessCoords.new("H", 5)
    table.put(pawn_w, from)
    expect{table.move(from, to)}.to raise_error("Illegal move!")
  end

  it "black cannot move two fields if not on starting position" do
    from = ChessCoords.new("H", 6)
    to   = ChessCoords.new("H", 4)
    table.put(pawn_b, from)
    expect{table.move(from, to)}.to raise_error("Illegal move!")
  end

  it "white can move one field diagonaly to eat black" do
    from = ChessCoords.new("D", 4)
    to   = ChessCoords.new("C", 5)
    table.put(pawn_w, from)
    table.put(pawn_b, to)
    table.move(from, to)
    expect(table.get_figure(to)).to be(pawn_w)
  end

  it "black can move one field diagonaly to eat white" do
    from = ChessCoords.new("F", 4)
    to   = ChessCoords.new("G", 3)
    table.put(pawn_b, from)
    table.put(pawn_w, to)
    table.move(from, to)
    expect(table.get_figure(to)).to be(pawn_b)
  end
end
