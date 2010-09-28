require File.join(File.dirname(__FILE__), "..","spec_helper")

module Chess
  describe Game do
    before(:each) do
      @game = Game.new(StartingPositions::Standard.new)
    end
    
    it "should be white's turn first and then black's turn" do
      @game.whos_turn?.should == :white
      @game.apply(Move.new('a2', 'a3'))
      @game.whos_turn?.should == :black
    end

    it "should not allow opponents to move out of turn" do
      lambda{ @game.apply(Move.new('a7', 'a6')) }.should raise_error(Game::OutOfTurnError)
    end
  end
end
