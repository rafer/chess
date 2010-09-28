require File.join(File.dirname(__FILE__), "..", "..", "spec_helper")

module Chess
  module StartingPositions
    include Chess::Pieces
    describe FischerRandom do
      before(:each) do
        @board = Board.new
        StartingPositions::FischerRandom.new.setup(@board)
      end

      it "should have 16 white pieces" do
        @board.pieces.select{ |p| p.color == :white }.size.should == 16
      end

      it "should have 16 black pieces" do
        @board.pieces.select{ |p| p.color == :black }.size.should == 16
      end

      it "should home rows that contain all of the standard pieces" do
        [[:white, 1], [:black, 8]].each do |color, home_row_number|
          @board.row(home_row_number).should =~ Standard::HOME_ROW.map{|k| k.new(color)}
        end
      end
    end
  end
end