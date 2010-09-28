require File.join(File.dirname(__FILE__), "..", "..", "spec_helper")

module Chess
  module Pieces
    describe Rook do
      include TextBoardHelpers

      before(:each) do
        @board = this_board(%q{
          . . . . . . . .
          . . . . . . . .
          . . . . . . . .
          . . . R . . . .
          . . . . . . . .
          . . . . . . . .
          . . . . . . . .
          . . . . . . . .          
        })

        @rook = @board.pieces.first
      end
      
      it "should move up and down and right and left" do
        @rook.possible_squares.should =~ these_squares(%{
          . . . x . . . .
          . . . x . . . .
          . . . x . . . .
          x x x . x x x x
          . . . x . . . .
          . . . x . . . .
          . . . x . . . .
          . . . x . . . .
        })

    end
      
      it "should not be able to move through pieces of the same color" do
        @board.place('d7', Rook.new(:white))

        @rook.possible_squares.should =~ these_squares(%{
          . . . . . . . .
          . . . . . . . .
          . . . x . . . .
          x x x . x x x x
          . . . x . . . .
          . . . x . . . .
          . . . x . . . .
          . . . x . . . .
        })
      end
      
      it "should be able to take pieces of the opposite color, but not advance any further" do
        @board.place('d7', Rook.new(:black))

        @rook.possible_squares.should =~ these_squares(%{
          . . . . . . . .
          . . . x . . . .
          . . . x . . . .
          x x x . x x x x
          . . . x . . . .
          . . . x . . . .
          . . . x . . . .
          . . . x . . . .
        })
      end
    end
  end
end