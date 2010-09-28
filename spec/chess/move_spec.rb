require File.join(File.dirname(__FILE__), "..","spec_helper")

module Chess
  describe Move do
    include TextBoardHelpers

    it "should actually move the pieces" do
      @board = Board.new
      StartingPositions::Standard.new.setup(@board)

      move = Move.new('a2','a3')
      move.bind(@board)
      move.execute
      
      @board['a3'].should == Pieces::Pawn.new(:white)
      @board['a2'].should be_nil

      move = Move.new('b8', 'c6')
      move.bind(@board)
      move.execute

      @board['c6'].should == Pieces::Knight.new(:black)
      @board['b8'].should be_nil
    end
    
    it "should move the pieces back when a move is undone" do
      board = this_board(%q{
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . r . . . .
        . . . . . . . .
        . . . . . . . .
      })
      
      move = Move.new('d3', 'h3')
      move.bind(board)      
      move.execute

      board.should == this_board(%q{
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . r
        . . . . . . . .
        . . . . . . . .
      })
      
      move.undo
      
      board.should == this_board(%q{
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . r . . . .
        . . . . . . . .
        . . . . . . . .
      })
    end
    
    it "should replace taken pieces when a move is undone" do
      board = this_board(%q{
        . . . . . . . .
        . . . . . . b .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . B . . . . . .
        . . . . . . . .
      })
      
      move = Move.new('b2','g7')
      move.bind(board)

      move.execute
      move.undo
      
      board.should == this_board(%q{
        . . . . . . . .
        . . . . . . b .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . B . . . . . .
        . . . . . . . .
      })
    end
    
    it "should report taken pieces" do
      board = Board.new

      white_rook = Pieces::Rook.new(:white)
      board['a1'] = white_rook

      black_rook = Pieces::Rook.new(:black)
      board['a8'] = black_rook
      
      move = Move.new('a1', 'a8')
      move.bind(board)
      move.execute
      
      board['a1'].should be_nil
      board['a8'].should be_equal(white_rook)
      move.captured_piece.should be_equal(black_rook)
    end
    
    it "should not perform illegal moves" do
      board = Board.new
      board['a1'] = Pieces::Rook.new(:white)
      
      move = Move.new('a1', 'b2')
      move.bind(board)
      
      move.should_not be_legal
      lambda { move.execute }.should raise_error(Move::IllegalMove)
    end
  end
end