require File.join(File.dirname(__FILE__), "..", "..", "spec_helper")

module Chess
  module Pieces
    describe Knight do
      include TextBoardHelpers
      
      before(:each) do
        @board = this_board(%q{
          . . . . . . . .
          . . . . . . . .
          . . . . . . . .
          . . . . . . . .
          . . . . N . . .
          . . . . . . . .
          . . . . . . . .
          . . . . . . . .
        })        

        @knight = @board.pieces.first
      end

      it "should be able to make the standard l-shaped move" do
        @knight.possible_squares.should =~ these_squares(%{
          . . . . . . . .
          . . . . . . . .
          . . . x . x . .
          . . x . . . x .
          . . . . . . . .
          . . x . . . x .
          . . . x . x . .
          . . . . . . . .
        })
      end
      
      it "should be able to jump over other pieces" do
        pawn_squares = these_squares(%q{
          . . . . . . . .
          . . . . . . . .
          . . . . . . . .
          . . . x x x . .
          . . . x . x . .
          . . . x x x . .
          . . . . . . . .
          . . . . . . . .
        })
        
        for square in pawn_squares
          @board[square] = Pawn.new(:white)
        end

        @knight.possible_squares.should =~ these_squares(%{
          . . . . . . . .
          . . . . . . . .
          . . . x . x . .
          . . x . . . x .
          . . . . . . . .
          . . x . . . x .
          . . . x . x . .
          . . . . . . . .
        })        
      end
    end
  end
end