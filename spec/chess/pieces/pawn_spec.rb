require File.join(File.dirname(__FILE__), "..", "..", "spec_helper")

module Chess
  module Pieces
    describe Pawn do
      include TextBoardHelpers

      before(:each) do
        @board = Chess::Board.new
      end

      it "should be able to move one square forward from the starting position" do
        StartingPositions::Standard.new.setup(@board)
        pawn = @board['a2']
        pawn.possible_squares.should include(Square.new('a3'))
      end

      describe "#adjacent_opposite_color_pawns" do
        it "should not include pawns of the same color" do
          board = this_board(%q{
            . . . . . . . .
            . . . . . . . .
            . . . . . . . .
            . . . . . . . .
            . . . . . . . .
            . . . . . . . .
            . . P P P . . .
            . . . . . . . .
          })
          
          pawn = board['d2']
          pawn.send(:adjacent_opposite_color_pawns).should == []
        end

        it "should should adjacent pawns of the opposite color" do
          board = this_board(%q{
            . . . . . . . .
            . . . . . . . .
            . . . . . . . .
            . . . . . . . .
            . . . . . . . .
            . . . . . . . .
            . . p P p . . .
            . . . . . . . .
          })
          
          pawn = board['d2']
          pawn.send(:adjacent_opposite_color_pawns).should == [board['c2'], board['e2']]
        end


        it "should not include adjacent non-pawn" do
          board = this_board(%q{
            . . . . . . . .
            . . . . . . . .
            . . . . . . . .
            . . . . . . . .
            . . . . . . . .
            . . . . . . . .
            . . k P b . . .
            . . . . . . . .
          })
          
          pawn = board['d2']
          pawn.send(:adjacent_opposite_color_pawns).should == []
        end

        it "should not include nil elements of the array if there is only one adjacent opposite color pawn" do
          board = this_board(%q{
            . . . . . . . .
            . . . . . . . .
            . . . . . . . .
            . . . . . . . .
            . . . . . . . .
            . . . . . . . .
            . . . P p . . .
            . . . . . . . .
          })
          
          pawn = board['d2']
          pawn.send(:adjacent_opposite_color_pawns).should == [board['e2']]
        end
      end

      context "is white" do
        before(:each) do
          @pawn = Pawn.new(:white)
        end

        it "should be able to move one square forward unless a piece is blocking it" do
          @board['e4'] = @pawn
          @pawn.possible_squares.should include(Square.new('e5'))

          @board['e5'] = Pawn.new(:black)
          @pawn.possible_squares.should be_empty
        end

        it "should be able to move two squares forward from the starting position unless a piece is blocking it " do
          @board['e2'] = @pawn
          @pawn.possible_squares.should include(Square.new('e4'))

          black_pawn = Pawn.new(:black)
          @board['e3'] = black_pawn
          @pawn.possible_squares.should_not include(Square.new('e4'))

          @board.pick_up('e3')
          @pawn.possible_squares.should include(Square.new('e4'))
          @board['e4'] = black_pawn
          @pawn.possible_squares.should_not include(Square.new('e4'))
        end
        
        it "should not be able to move two squares forward if it is not on the starting line" do
          @board['e3'] = @pawn
          @pawn.possible_squares.should_not include(Square.new('e5'))
        end

        it "should be able to take diagonally forward 1 square" do
          forward_left, forward_right = Square.new('e5'), Square.new('g5')

          @board['f4'] = @pawn

          @pawn.possible_squares.should_not include(forward_left, forward_right)

          @board[forward_left] = Pawn.new(:black)
          @board[forward_right] = Pawn.new(:black)
          @pawn.possible_squares.should include(forward_left, forward_right)

          @board.pick_up(forward_left)
          @board.pick_up(forward_right)
          @board[forward_left] = Pawn.new(:white)
          @board[forward_right] = Pawn.new(:white)
          @pawn.possible_squares.should_not include(forward_left, forward_right)
        end
      end

      context "is black" do
        before(:each) do
          @pawn = Pawn.new(:black)
        end

        it "should be able to move one square forward unless a piece is blocking it" do
          @board['e4'] = @pawn
          @pawn.possible_squares.should include(Square.new('e3'))

          @board['e3'] = Pawn.new(:white)
          @pawn.possible_squares.should be_empty
        end

        it "should be able to move two squares forward unless a piece is blocking it from the starting position" do
          @board['e7'] = @pawn
          @pawn.possible_squares.should include(Square.new('e5'))

          white_pawn = Pawn.new(:white)
          @board['e6'] = white_pawn
          @pawn.possible_squares.should_not include(Square.new('e5'))

          @board.pick_up('e6')
          @pawn.possible_squares.should include(Square.new('e5'))
          @board['e5'] = white_pawn
          @pawn.possible_squares.should_not include(Square.new('e5'))

        end

        it "should not be able to move two squares forward if it is not on the starting line" do
          @board['e6'] = @pawn
          @pawn.possible_squares.should_not include(Square.new('e4'))
        end

        it "should be able to take diagonally forward 1 square" do
          forward_left, forward_right = Square.new('e3'), Square.new('g3')

          @board['f4'] = @pawn

          @pawn.possible_squares.should_not include(forward_left, forward_right)

          @board[forward_left] = Pawn.new(:white)
          @board[forward_right] = Pawn.new(:white)
          @pawn.possible_squares.should include(forward_left, forward_right)

          @board.pick_up(forward_left)
          @board.pick_up(forward_right)
          @board[forward_left] = Pawn.new(:black)
          @board[forward_right] = Pawn.new(:black)
          @pawn.possible_squares.should_not include(forward_left, forward_right)
        end
      end
    end
  end
end
