require File.join(File.dirname(__FILE__), "..", "..", "spec_helper")

module Chess
  module Pieces
    describe Bishop do
      include TextBoardHelpers
      
      before(:each) do
        @board = this_board(%q{
          . . . . . . . .
          . . . . . . . .
          . . . . . . . .
          . . . . . . . .
          . . . . B . . .
          . . . . . . . .
          . . . . . . . .
          . . . . . . . .
        })

        @bishop = @board.pieces.first
      end
      
      it "should be able to move along diagonals" do
        @bishop.possible_squares.should =~ these_squares(%{
          x . . . . . . .
          . x . . . . . x
          . . x . . . x .
          . . . x . x . .
          . . . . . . . .
          . . . x . x . .
          . . x . . . x .
          . x . . . . . x
        })
      end
    end
  end
end