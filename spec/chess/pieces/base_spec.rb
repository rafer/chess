require File.join(File.dirname(__FILE__), "..", "..", "spec_helper")

module Chess
  module Pieces
    describe Base do
      it "should be able to tell you what color it is" do
        piece = Pawn.new(:black)
        piece.color.should == :black
      end

      it "should be able to tell you what type of piece it is" do
        piece = Pawn.new(:black)
        piece.class == Pawn
      end
    
      it "should represent its self as an uppercase letter if it is white and lowercase if black" do
        Pawn.new(:white).to_s.should == 'P'
        Pawn.new(:black).to_s.should == 'p'
      end    

      it "should be able to give you a piece object from a single character" do
        Pieces::Base.from_character('p').should == Pawn.new(:black)
        Pieces::Base.from_character('P').should == Pawn.new(:white)

        # Specifically checking knight and king becase Knight is the only
        # piece so far that has a custom character
        Pieces::Base.from_character('n').should == Knight.new(:black)
        Pieces::Base.from_character('N').should == Knight.new(:white)

        Pieces::Base.from_character('k').should == King.new(:black)
        Pieces::Base.from_character('K').should == King.new(:white)

      end
    end
  end
end
