require File.join(File.dirname(__FILE__), "..", "..", "spec_helper")

module Chess
  module StartingPositions
    describe FromString do
      include TextBoardHelpers
      
      it "should read in this random position properly" do
        board = Board.new
        FromString.new(%q{
          r n b q k b n r
          p p p p p p p p
          . . . . . . . .
          . . . . . . . .
          . . . . . . . .
          . . . . . . . .
          P P P P P P P P
          R N B Q K B N R
        }).setup(board)
        
        board.should == this_board(%q{
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
    end
  end
end