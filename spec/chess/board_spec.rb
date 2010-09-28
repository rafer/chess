require File.join(File.dirname(__FILE__), "..","spec_helper")

module Chess
  describe Board do
    include TextBoardHelpers
    
    context "from a new standard game" do
      before(:each) do
        @board = Board.new
        StartingPositions::Standard.new.setup(@board)
      end

      it "should have all of the pieces in the correct position" do
        @board.should == this_board(%{
          r n b q k b n r
          p p p p p p p p
          . . . . . . . .
          . . . . . . . .
          . . . . . . . .
          . . . . . . . .
          P P P P P P P P
          R N B Q K B N R
        })
      end

      it "should remove all of the pieces when cleared" do
        @board.clear
        @board.should == this_board(%{
          . . . . . . . .
          . . . . . . . .
          . . . . . . . .
          . . . . . . . .
          . . . . . . . .
          . . . . . . . .
          . . . . . . . .
          . . . . . . . .
        })        
        @board.pieces.should be_empty
      end

      it "should give you the square of a piece on the board" do
        piece = Pieces::Pawn.new(:black)
        @board['d5'] = piece
        
        @board.square_of(piece).to_s.should == 'd5'
        @board[piece].to_s.should == 'd5'
      end

      it "should tell you what piece is at a particular square" do 
        @board.at('a1').to_s.should == 'R'
        @board['a1'].to_s.should == 'R'
      end

      it "should return nil when you get the contents of an empty square" do
        @board.at('a3').should be_nil
        @board['a3'].should be_nil
      end

      it "should be able to take a piece off the board" do
        @board['a2'].should.to_s == 'P'
        @board.pick_up('a2').to_s.should == 'P'
        @board['a2'].should be_nil
      end

      it "should be able to put a piece on the board" do
        piece = @board.pick_up('b2')        
        @board['a5'] = piece
        @board['a5'].should.equal?(piece)
      end

      it "should not allow you to place the same piece on the board twice" do
        piece = @board['a2']
        lambda{ @board['a3'] = piece }.should raise_error(/cannot place the same piece (.+) the board twice/)
      end

      it "should not be able to place 'nothing' (nil)" do
        lambda{ @board.place('a3', nil) }.should raise_error("cannot place nil on the board")
        lambda{ @board['a3'] = nil }.should raise_error("cannot place nil on the board")
      end

      it "should not allow you to place a piece on another piece's square" do
        lambda{ @board['a2'] = @board['a3'] }.should raise_error("cannot place a piece on another piece's square")
      end

      it "should give you the pieces on the board" do
        starting_pieces = []
        for piece in StartingPositions::Standard::HOME_ROW
          starting_pieces << piece.new(:white)
          starting_pieces << piece.new(:black)
        end
        
        8.times{ starting_pieces << Pieces::Pawn.new(:white) }
        8.times{ starting_pieces << Pieces::Pawn.new(:black) }

        @board.pieces.should =~ starting_pieces
      end
      
      describe "#move" do
        it "moves the piece from the starting square to the ending square" do
          @board.move('d2', 'd4').should == this_board(%{
            r n b q k b n r
            p p p p p p p p
            . . . . . . . .
            . . . . . . . .
            . . . P . . . .
            . . . . . . . .
            P P P . P P P P
            R N B Q K B N R
          })
        end
        
        it "should raise an IllegalMove error for illegal moves" do
          lambda { @board.move('d2', 'd5') }.should raise_error(Move::IllegalMove)
        end
      end
    end
  end
end