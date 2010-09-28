require File.join(File.dirname(__FILE__), "..", "..", "spec_helper")

module Chess
  module Pieces
    describe King do
      include TextBoardHelpers
      
      before(:each) do

        @board = this_board(%q{
          . . . . . . . .
          . . . . . . . .
          . . . . . . . .
          . . . . . . . .
          . . . . K . . .
          . . . . . . . .
          . . . . . . . .
          . . . . . . . .
        })

        @king = @board.pieces.first
      end
      
      it "should be able to move one square in every direction" do
        @king.possible_squares.should =~ these_squares(%{
          . . . . . . . .
          . . . . . . . .
          . . . . . . . .
          . . . x x x . .
          . . . x . x . .
          . . . x x x . .
          . . . . . . . .
          . . . . . . . .
        })
      end
    end
  end
end