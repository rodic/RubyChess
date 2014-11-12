require 'coords'

describe ChessCoords do
  describe "#new" do

    context "Coords are valide" do
    
      it "can be properly initialized with cartesian coords" do
        expect(ChessCoords.new(0, 4).to_s).to eq("(A, 5)")
      end

      it "can be properly initialized with standard chess coords" do
        expect(ChessCoords.new("H", 7).to_s).to eq("(H, 7)")
      end
    end

    context "Coords are invalide" do
      it "raises 'Invalid coords' when cartesian coords are negative" do
        expect {ChessCoords.new(-1, 4)}.to raise_error("Invalid coords!")
      end

      it "raises 'Invalid coords' when cartesian coords are out of the range" do
        expect {ChessCoords.new(0, 8)}.to raise_error("Invalid coords!")
      end
    end
  end

  describe "#in_same_column?" do
    it "returns True when two coords are in the same column" do
      c1 = ChessCoords.new("G", 6)
      c2 = ChessCoords.new("G", 2)
      expect(c1.in_same_column?(c2)).to be_truthy
    end

    it "returns False when two coords aren't in the same column" do
      c1 = ChessCoords.new("B", 3)
      c2 = ChessCoords.new("C", 2)
      expect(c1.in_same_column?(c2)).to be_falsey
    end
  end

  describe "#in_the_same_row?" do
    it "returns True when two coords are in the same row" do
      c1 = ChessCoords.new("G", 3)
      c2 = ChessCoords.new("B", 3)
      expect(c1.in_same_row?(c2)).to be_truthy
    end

    it "returns False when two coords are not in the same row" do
      c1 = ChessCoords.new("E", 2)
      c2 = ChessCoords.new("F", 1)
      expect(c1.in_same_row?(c2)).to be_falsey
    end
  end

  describe "#on_same_rising_diagonal?" do
    it "returns True when two coords are on the same rising diagonal" do
      c1 = ChessCoords.new("C", 2)
      c2 = ChessCoords.new("G", 6)
      expect(c1.on_same_rising_diagonal?(c2)).to be_truthy
    end

    it "returns True when two coords aren't on the same rising diagonal" do
      c1 = ChessCoords.new("E", 1)
      c2 = ChessCoords.new("H", 3)
      expect(c1.on_same_rising_diagonal?(c2)).to be_falsey
    end
  end

  describe "#on_same_falling_diagonal?" do
    it "returns True when two coords are on the same falling diagonal" do
      c1 = ChessCoords.new("F", 2)
      c2 = ChessCoords.new("A", 7)
      expect(c1.on_same_falling_diagonal?(c2)).to be_truthy
    end

    it "returns True when two coords aren't on the same right (\\) diagonal" do
      c1 = ChessCoords.new("E", 1)
      c2 = ChessCoords.new("C", 5)
      expect(c1.on_same_falling_diagonal?(c2)).to be_falsey
    end
  end

  describe "#get_vertical_path" do
    context "Coords are in the same column" do
      let(:c1) { ChessCoords.new("E", 1) }
      let(:c2) { ChessCoords.new("E", 4) }
      let(:res){ [ c1, ChessCoords.new("E", 2), ChessCoords.new("E", 3), c2 ] }
    
      it "returns correct path from bottom to top" do
        expect(c1.get_vertical_path(c2)).to eq(res)
      end

      it "returns correct path from top to bottom" do
        expect(c2.get_vertical_path(c1)).to eq(res.reverse)
      end
    end

    context "Coords are not in the same column" do
      it "raises error 'Invalid coords!'" do
        c1 = ChessCoords.new("C", 1)
        c2 = ChessCoords.new("D", 4)
        expect {c1.get_vertical_path(c2)}.to raise_error("Invalid coords!")
      end
    end
  end

  describe "#get_horizontal_path" do
    context "Coords are in the same row" do
      let(:c1)  { ChessCoords.new("B", 5) }
      let(:c2)  { ChessCoords.new("E", 5) }
      let(:res) { [c1, ChessCoords.new("C", 5), ChessCoords.new("D", 5), c2] }

      it "returns correct path from left to right" do
        expect(c1.get_horizontal_path(c2)).to eq(res)
      end

      it "returns correct path from right to left" do
        expect(c2.get_horizontal_path(c1)).to eq(res.reverse)
      end
    end

    context "Coords are not in the same row" do
      it "raises error 'Invalid coords!'" do
        c1 = ChessCoords.new("B", 7)
        c2 = ChessCoords.new("E", 8)
        expect { c1.get_horizontal_path(c2) }.to raise_error("Invalid coords!")
      end
    end
  end

  describe "#get_rising_diagonal_path" do
    context "Coords are on the same left diagonal" do
      let(:c1)  { ChessCoords.new("D", 3) }
      let(:c2)  { ChessCoords.new("G", 6) }
      let(:res) { [ c1, ChessCoords.new("E", 4), ChessCoords.new("F", 5), c2 ] }

      it "returns correct path from bottom to top" do
        expect(c1.get_rising_diagonal_path(c2)).to eq(res)
      end

      it "returns correct path from top to bottom" do
        expect(c2.get_rising_diagonal_path(c1)).to eq(res.reverse)
      end
    end

    context "Coords are not on the same left diagonal" do
      it "raises error 'Invalid coords!'" do
        c1 = ChessCoords.new("A", 1)
        c2 = ChessCoords.new("B", 3)
        expect{c1.get_rising_diagonal_path(c2)}.to raise_error("Invalid coords!")
      end
    end
  end

  describe "get_falling_diagonal_path" do

    context "Coords are on the same falling diagonal" do
      let(:c1)  { ChessCoords.new("F", 3) }
      let(:c2)  { ChessCoords.new("C", 6) }
      let(:res) { [c1, ChessCoords.new("E", 4), ChessCoords.new("D", 5), c2] }

      it "returns correct path from bottom to top" do
        expect(c1.get_falling_diagonal_path(c2)).to eq(res)
      end

      it "returns correct path from top to bottom" do
        expect(c2.get_falling_diagonal_path(c1)).to eq(res.reverse)
      end
    end

    context "Coords are not on the same falling diagonal" do
      it "raises error 'Invalid coords!'" do
        c1 = ChessCoords.new("D", 5)
        c2 = ChessCoords.new("C", 7)
        expect{c1.get_falling_diagonal_path(c2)}.to raise_error("Invalid coords!")
      end
    end
  end
end
