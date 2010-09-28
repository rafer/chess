require File.join(File.dirname(__FILE__), "..", "..", "spec_helper")

module Chess
  module Pieces
    describe Queen do
      include TextBoardHelpers
      
      before(:each) do
        @board = this_board(%q{
          . . . . . . . .
          . . . . . . . .
          . . . . . . . .
          . . . . . . . .
          . . . . Q . . .
          . . . . . . . .
          . . . . . . . .
          . . . . . . . .
        })

        @queen = @board.pieces.first
      end
      
      it "should be able to up and down, left and right, and along diagonals" do
        @queen.possible_squares.should =~ these_squares(%{
          x . . . x . . .
          . x . . x . . x
          . . x . x . x .
          . . . x x x . .
          x x x x . x x x
          . . . x x x . .
          . . x . x . x .
          . x . . x . . x
        })
      end
    end
  end
end